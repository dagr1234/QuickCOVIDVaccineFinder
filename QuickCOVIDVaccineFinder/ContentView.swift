//
//  ContentView.swift
//  QuickCOVIDVaccineFinder
//
//  Created by David Grossman on 4/22/21.
//
// queries vaccinespootter.org --- built by a truly helpful person and displays result on iOS Device

import SwiftUI


struct ContentView: View {
    
    @State var allVaccineSites : [VaccineEntry] = []
    @State var numAvailable : Int = 0
    
    func incrementNumAvailable() {
        self.numAvailable = self.numAvailable + 1
    }
    
    func load() {
        
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
                                self.numAvailable = self.numAvailable + 1
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
            }.resume()
            
        }
    
    
    
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
                            Text("Available Vaccines: ").font(.custom("Colonna MT Regular", size: 25))
                                //.font(.headline)
                            Text("Total Locations: \(self.allVaccineSites.count)")
                            Text("Number Available with Vaccine: \(self.numAvailable)")
                            Text("Click name for more information")
                            Link("Thanks to Excellent Vaccine Spotter", destination: URL(string: "https://www.vaccinespotter.org")!)
                            Text(" ")
                        }
                        //.edgesIgnoringSafeArea(.all)  d

                        Spacer()
                        
                    }.background(Color.yellow)
                        .edgesIgnoringSafeArea(.all)
                    Divider().background(Color.black).frame(height: 0).frame(height: 10).background(Color.black).padding(0)
                        .offset(x: 0, y: -60.0/*@END_MENU_TOKEN@*/)
                   
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
            }
        }
    }
        

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
