//
//  ContentView.swift
//  QuickCOVIDVaccineFinder
//
//  Created by David Grossman on 4/22/21.
//
// queries vaccinespootter.org --- built by a truly helpful person and displays result on iOS Device
//
import SwiftUI
import CoreLocation

enum Vaccine {
    case Pfizer
    case Moderna
    case JJ
}

struct ContentView: View {
    
    let NUMBER_OF_VACCINES = 3
    @ObservedObject var locationManager = LocationManager()
    @State var allVaccineSites : [VaccineEntry] = []
    @State var numAvailable    : Int = 0
    @State var loading         : Bool = false
    @State private var isLoading = false
    @State var showSplash      : Bool = true
    @State var vaccineSelected : [Vaccine] = [Vaccine.Pfizer, Vaccine.Moderna, Vaccine.JJ]
    
    
    func load(state : String) {
        
            self.allVaccineSites = []
            self.loading = true
            self.numAvailable = 0
        
        
            let userLocation = locationManager.location
 
            guard let url = URL(string: "https://www.vaccinespotter.org/api/v0/states/"+state+".json") else {
              
            print("Invalid URL")
                return
            }
            let request = URLRequest(url: url)

            URLSession.shared.dataTask(with: request) { data, response, error in
                guard let json = try? JSON(data : data!) else {
                    return
                }
                for features in json["features"].arrayValue {
                    var vaccine : VaccineEntry = VaccineEntry()

                    for properties in features["geometry"] {
                        if (properties.0 == "type") {
                            vaccine.location_type = properties.1.stringValue
                        }
                        
                        if (properties.0 == "coordinates") {
                            vaccine.longitude = properties.1.arrayValue[0].floatValue
                            vaccine.lattitude = properties.1.arrayValue[1].floatValue
                           
                            
                            let vaccineLocation =  CLLocation(latitude  : Double(vaccine.lattitude),
                                                              longitude : Double(vaccine.longitude))
                            
                            
                            let distanceInMeters = userLocation?.distance(from: vaccineLocation )
                            
                            vaccine.distanceFromUser = Double(0.000621371) * (distanceInMeters ?? 0.0)
                        }
                    }
            
                    
                    for properties in features["properties"] {
            
                        if (properties.0 == "url") {
                            vaccine.url = properties.1.stringValue
                        }
                        
                        if (properties.0 == "id") {
                            vaccine.id = properties.1.intValue
                        }
                        
                        if (properties.0 == "provider") {
                            vaccine.provider = properties.1.stringValue
                        }
                        
                        if (properties.0 == "city") {
                            vaccine.city = properties.1.stringValue
                        }
                        
                        if (properties.0 == "state") {
                            vaccine.state = properties.1.stringValue
                        }
                        
                        if (properties.0 == "postal_code") {
                            vaccine.zip_code = properties.1.stringValue
                        }
                        
                        if (properties.0 == "address") {
                            vaccine.address = properties.1.stringValue
                        }
                        
                        if (properties.0 == "appointments_available") {
                            vaccine.appointments_available = properties.1.boolValue
                            if (vaccine.appointments_available) {
                                if (self.vaccineSelected.count == NUMBER_OF_VACCINES) {
                                    self.numAvailable = self.numAvailable + 1
                                }
                            }
                        }

                        var incrementFlag = true
                        if (properties.0 == "appointment_vaccine_types") {
                            for (vaccineType, vaccineFlag) in properties.1 {
                                if (vaccineType == "jj" && vaccineFlag.boolValue) {
                                    vaccine.vaccineTypes.append("Johnson & Johnson")
                                    if (self.vaccineSelected.contains(Vaccine.JJ)) {
                                        self.numAvailable = self.numAvailable + 1
                                        incrementFlag = false
                                    }
                                }
                                if (vaccineType == "pfizer" && vaccineFlag.boolValue) {
                                    vaccine.vaccineTypes.append("Pfizer")
                                    if (self.vaccineSelected.contains(Vaccine.Pfizer) && (incrementFlag)) {
                                        self.numAvailable = self.numAvailable + 1
                                        incrementFlag = false
                                    }
                                    
                                }
                                if (vaccineType == "moderna" && vaccineFlag.boolValue) {
                                    vaccine.vaccineTypes.append("Moderna")
                                    if (self.vaccineSelected.contains(Vaccine.Moderna) && (incrementFlag)) {
                                        self.numAvailable = self.numAvailable + 1
                                    }
                                }
                            }
                        }
                        
                        if (properties.0 == "provider_brand_name") {
                            vaccine.provider_brand_name = properties.1.stringValue
                        }
                    }
                    
                    DispatchQueue.main.async {
                        self.allVaccineSites.append(vaccine)
                    }
                    
                }
                self.loading = false
            }.resume()
            
        }
    
    // remove a vaccine from the list of selected vaccines
    func removeVaccine(vaccineToRemove : Vaccine) {
        var result : [Vaccine] = []
        for current in self.vaccineSelected {
            if (current != vaccineToRemove) {
                result.append(current)
            }
        }
        self.vaccineSelected = result
    }
    
    // sort vaccine sites by distance from user
    func getVaccineSitesSortedByDistance(filter : [Vaccine]) -> [VaccineEntry] {
        if (filter.count == NUMBER_OF_VACCINES) {
            return allVaccineSites.sorted { $0.distanceFromUser < $1.distanceFromUser}
        }
        
        let vaccineSites = allVaccineSites.sorted { $0.distanceFromUser < $1.distanceFromUser}
        var finalSites : [VaccineEntry] = []
        for site in vaccineSites {
            if (filter.contains(Vaccine.Moderna)) && (site.vaccineTypes.contains("Moderna")) {
                finalSites.append(site)
            } else {
                if (filter.contains(Vaccine.Pfizer)) && (site.vaccineTypes.contains("Pfizer")) {
                    finalSites.append(site)
                }
                else {
                    if (filter.contains(Vaccine.JJ)) && (site.vaccineTypes.contains("Johnson & Johnson")) {
                        print("JJ")
                        finalSites.append(site)
                    }
                }
            }
            
        }
        return finalSites
    }
    
   
    
    var body: some View {
        ZStack {
            if (self.showSplash) {
                SplashView()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                                self.showSplash = false
                        
                            
                        }
                    }
            } else {
        
        GeometryReader { geometry in
                ZStack {
                    VStack {
                        HStack {
                            Spacer()
                                VStack {
                                    HeaderView(numberOfSites : self.allVaccineSites.count,
                                               numberOfAvailableSites : self.numAvailable)
                                
                                    Group {
                                        HStack {
                                            // Moderna Button
                                            Button(action: {
                                                let userState = locationManager.placemark?.administrativeArea ?? "VA"
                                                
                                                if (self.vaccineSelected.contains(Vaccine.Moderna)) {
                                                    self.removeVaccine(vaccineToRemove : Vaccine.Moderna)
                                                } else {
                                                    self.vaccineSelected.append(Vaccine.Moderna)
                                                }
                                                self.load(state : userState)
                                            }) {
                                                HStack {
                                                    Text("Moderna")
                                                        .fontWeight(.semibold)
                                                        .clipShape(Rectangle())
                                                        .mask(Rectangle())
                                                    
                                                
                                                }
                                        }
                                        .frame(minWidth: 0, maxWidth: 200,alignment: .center)
                                        .padding()
                                        .foregroundColor(.black)
                                        .background(Colors.SpecialNyanza)
                                        .cornerRadius(40)
                                        .zIndex(1)
                                        .clipShape(Rectangle())
                           
                                    // Pfizer Button
                                    Button(action: {
                                        let userState = locationManager.placemark?.administrativeArea ?? "VA"
                                        
                                        if (self.vaccineSelected.contains(Vaccine.Pfizer)) {
                                            self.removeVaccine(vaccineToRemove : Vaccine.Pfizer)
                                        } else {
                                            self.vaccineSelected.append(Vaccine.Pfizer)
                                        }
                                    
                                        self.load(state : userState)
                                        }) {
                                            HStack {
                                                Text("Pfizer")
                                                    .fontWeight(.semibold)
                                                    .clipShape(Rectangle())
                                                    .mask(Rectangle())
                                        
                                            }
                                    }
                                    .frame(minWidth: 0, maxWidth: 200,alignment: .center)
                                    .padding()
                                    .foregroundColor(Color.black)
                                    .background(Colors.SpecialNyanza)
                                    .cornerRadius(40)
                                    .zIndex(1)
                                    .clipShape(Rectangle())
                                        
                                    Button(action: {
                                        let userState = locationManager.placemark?.administrativeArea ?? "VA"
                                        if (self.vaccineSelected.contains(Vaccine.JJ)) {
                                            self.removeVaccine(vaccineToRemove : Vaccine.JJ)
                                        } else {
                                            self.vaccineSelected.append(Vaccine.JJ)
                                        }
                                        self.load(state : userState)
                                    }) {
                                        HStack {
                                                Text("J&J")
                                                    .fontWeight(.semibold)
                                                    .clipShape(Rectangle())
                                                
                                                }
                                        }
                                        .frame(minWidth: 0, maxWidth: 120,alignment: .center)
                                        .padding()
                                        .foregroundColor(.black)
                                        .background(Colors.SpecialNyanza)
                                        .cornerRadius(40)
                                        .zIndex(1)
                                        .clipShape(Rectangle())
                                    } //Hstack
                                } // Button Group
                            } //Vstack
                            Text(" ")
                        } //HStack
                        .offset(x: 0, y: 20)
                        
                        Spacer()
                        
                    } //Hstack
                    .background(Colors.SpecialBlue)
                        .edgesIgnoringSafeArea(.all)
                    .frame( height: 100)
                    Divider().background(Color.black).frame(height: 0).frame(height: 10).background(Color.black).padding(0)
                        .offset(x: 0, y: 60/*@END_MENU_TOKEN@*/)
                   
                    // output the list
                    if (!self.loading) {
                        ScrollView {
                            
                            ForEach(self.getVaccineSitesSortedByDistance(filter : vaccineSelected),
                                    id: \.self)
                              { vaccine in
                                if (vaccine.appointments_available) {
                                    ListView(vaccine : vaccine).animation(/*@START_MENU_TOKEN@*/.easeIn/*@END_MENU_TOKEN@*/)
                                }
                            }
                        }.offset(x: 0, y: 51)
                    }
                } // Zstack
            
            .onAppear() {
                
                let userState = locationManager.placemark?.administrativeArea ?? "VA"
                print("State ===> \(userState)")
                load(state : userState)
                
            }
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    ZStack {
                    
                        if (!self.loading) {
                            Button(action: {
                                let userState = locationManager.placemark?.administrativeArea ?? "VA"
                                self.load(state : userState)
                        }) {
                            HStack {
                                
                                Image(systemName: "arrow.clockwise")
                                    //.font(.title)
                                    //.mask(Circle())
                                Text("Refresh")
                                    .fontWeight(.semibold)
                                    //.font(.title)
                                    .clipShape(Rectangle())
                                    .mask(Rectangle())
                                    .frame(alignment: .trailing)
                                    
                                    
                            }
                            .frame(minWidth: 0, maxWidth: .infinity,alignment: .trailing)
                            .padding()
                            .foregroundColor(.black)
                            //.background(LinearGradient(gradient: Gradient(colors: [Color("DarkGreen"), Color("LightGreen")]), startPoint: .center, endPoint: .trailing))
                            .background(Colors.SpecialNyanza)
                            .cornerRadius(40)
                            .padding(.horizontal, 40)
                            .zIndex(1)
                            .clipShape(Rectangle())
                            .offset(x: 110, y: 10)
                            }
                        } else {
                            HStack{
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .black))
                                    .scaleEffect(1.5)
                            }.offset(x: 110, y: 10)

                        }
                    } // zStack
                } // Toolbar Item
            } // Toolbar
        } // Geometry Reader
    } // else (not splash screen)
  } // Zstack
} // View Body
} // Content View


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
