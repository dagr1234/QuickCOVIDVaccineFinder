//
//  ContentView.swift
//  QuickCOVIDVaccineFinder
//
//  Created by David Grossman on 4/22/21.
//

import SwiftUI


struct ContentView: View {
    
    @State var availableVaccines : [VaccineEntry] = []
    
    
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
                        }
                        
                        
                    }
                    DispatchQueue.main.async {
                        self.availableVaccines.append(vaccine)
                    }
                    
                }
            }.resume()
            
        }
    
    
    
    var body: some View {
        
        VStack {
            ForEach(self.availableVaccines, id: \.self) { vaccine in
                    Text(vaccine.url)
                          .padding()
                          
            }
        }.onAppear() {
            load()
        }
    }
        

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
