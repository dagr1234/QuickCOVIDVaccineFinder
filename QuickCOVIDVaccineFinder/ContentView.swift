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



struct ContentView: View {
    
    @State var allVaccineSites : [VaccineEntry] = []
    @State var numAvailable : Int = 0
    @State var cnt : Int = 0
    @State var loading : Bool = false
    @State private var isLoading = false
   
    
    func incrementNumAvailable() {
        self.numAvailable = self.numAvailable + 1
    }
    
    func load() {
        
            self.allVaccineSites = []
            self.numAvailable = 0
            self.cnt = 0
            self.loading = true
        
            print("Current Lat.Long")
        
        
        

        
            print("Starting load...")
            guard let url = URL(string: "https://www.vaccinespotter.org/api/v0/states/VA.json") else {
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
                    print(features)
                    for properties in features["geometry"] {
                        if (properties.0 == "type") {
                            vaccine.location_type = properties.1.stringValue
                        }
                        
                        if (properties.0 == "coordinates") {
                            vaccine.lattitude = properties.1.arrayValue[0].floatValue
                            vaccine.longitude = properties.1.arrayValue[1].floatValue
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
                                self.cnt = self.cnt + 1
                                self.numAvailable = self.numAvailable + 1
                                vaccine.counter = self.cnt 
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
    
    
    @ObservedObject var locationViewModel = LocationViewModel()
    
    var body: some View {
        
        
        GeometryReader { geometry in
//            ScrollView  {
                ZStack {
                VStack {
                    HStack {
                        Spacer()
                        VStack {
                            Text(" ")
                            Text(" ")
                            Text("Latitude: \(locationViewModel.userLatitude)")
                                    Text("Longitude: \(locationViewModel.userLongitude)")
                            Text("Available Vaccines: ").font(.custom("Colonna MT Regular", size: 25))
                                //.font(.headline)
                            Text("Total Locations: \(self.allVaccineSites.count)")
                            Text("Number Available with Vaccine: \(self.numAvailable)")
                            Text("Click location name for more information")
                            Link("Thanks goes to the Excellent Vaccine Spotter", destination: URL(string: "https://www.vaccinespotter.org")!)
                            Text(" ")
                        }
                        //.edgesIgnoringSafeArea(.all)  d

                        Spacer()
                        
                    }.background(Colors.SpecialBlue)
                        .edgesIgnoringSafeArea(.all)
                    .frame( height: 100)
                    Divider().background(Color.black).frame(height: 0).frame(height: 10).background(Color.black).padding(0)
                        .offset(x: 0, y: 8.0/*@END_MENU_TOKEN@*/)
                   
                    ScrollView {
                        
                    ForEach(self.allVaccineSites, id: \.self) { vaccine in
                        if (vaccine.appointments_available) {
                            ListView(vaccine : vaccine).animation(/*@START_MENU_TOKEN@*/.easeIn/*@END_MENU_TOKEN@*/)
                                //.frame(width: 100)
//                            ListView(vaccine : vaccine).frame(width: geometry.size.width)
//                                .frame(width: geometry.size.width)
                            
                        }
                    }
//                    Divider().background(Color.black).frame(height: 0).frame(height: 10).background(Color.black)
                }
                }
            }.onAppear() {
                load()
            }.toolbar {
                ToolbarItem(placement: .bottomBar) {
                    ZStack {
                        
                        HStack {
                            Link("\u{00A9}", destination: URL(string: "https://www.grossmanlabs.com")!)
                                .offset(x: -90, y: 10)
                            Text ("2021 Grossman Labs")
                                .offset(x: -90, y: 10)
                        }
//                    Text ("Grossman Labs 2021 ").frame(alignment: .leading)
//                        .offset(x: -200, y: 0)
                    
                        if (!self.loading) {
                            Button(action: {
                                self.load()
                                print("Edit tapped!")
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
                            
                          //  ZStack {
//
//                                        Circle()
//                                            .stroke(Color(.systemGray5), lineWidth: 7)
//                                            .frame(width: 25, height: 25)
//
//                                        Circle()
//                                            .trim(from: 0, to: 0.2)
//                                            .stroke(Colors.SpecialNyanza, lineWidth: 5)
//                                            .frame(width: 20, height: 20)
//                                            .rotationEffect(Angle(degrees: self.isLoading ? 360 : 0))
//                                            .animation(Animation.basic(duration: 10,curve: .linear).repeatForever(autoreverses: false))
//                                            .onAppear() {
//                                                self.isLoading = true
                                     //   }.offset(x: 110, y: 10)
                            }
//                            Text("Loading...")
//                                .offset(x: 110, y: 10)
                        }
//                    Button("Refresh") { //Add Refresh Logic here
//                        print("Pressed")
//                    }
//                    //.buttonStyle(CircleButtonStyle(bgColor: Color.blue))


        }
    }
        
            }
}

    }

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
