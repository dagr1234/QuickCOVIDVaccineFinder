//
//  ContentView.swift
//  QuickCOVIDVaccineFinder
//
//  Created by David Grossman on 4/22/21.
//

import SwiftUI


struct ContentView: View {
    
    @State var results : [VaccineEntry] = []
    
    
    func loadData() {
        
            var result : VaccineEntry = VaccineEntry()
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
                    print(features)
                    for properties in features["properties"] {
            
                        if (properties.0 == "url") {
                            result.url = properties.1.stringValue
                        }
                        
                        if (properties.0 == "id") {
                            result.id = properties.1.intValue
                        }
                        
                        if (properties.0 == "provider") {
                            result.provider = properties.1.stringValue
                        }
                        
                        if (properties.0 == "city") {
                            result.city = properties.1.stringValue
                        }
                        
                        if (properties.0 == "state") {
                            result.state = properties.1.stringValue
                        }
                        
                        if (properties.0 == "postal_code") {
                            result.zip_code = properties.1.stringValue
                        }
                        
                        if (properties.0 == "address") {
                            result.address = properties.1.stringValue
                        }
                        
                        if (properties.0 == "appointments_available") {
                            result.appointments_available = properties.1.boolValue
                        }
                        
                        
                    }
                    DispatchQueue.main.async {
                        results.append(result)
                    }
                    
                }
            }.resume()
            
        }
    
    
    
    var body: some View {
        
        VStack {
            Text("Results")
            
            List(results.identified(by: \.id)) { result in
                Text(result.url)
            }
            
        }.onAppear(perform: loadData)
            
    }
        

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
