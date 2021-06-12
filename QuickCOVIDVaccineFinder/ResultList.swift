//
//  ResultList.swift
//  QuickCOVIDVaccineFinder
//
//  Created by David Grossman on 5/28/21.
//

import Foundation
import CoreLocation
import SwiftUI

class ResultList : ObservableObject  {


    let NUMBER_OF_VACCINES = 3
    @Published  var sites     : [VaccineEntry] = []
    @Published  var available : Int = 0
    @Published  var dataIsLoaded : Bool = false

    var locationManager : LocationManager = LocationManager()
    
    
    init() {
        sites = []
        available = 0
        dataIsLoaded = false 
    }
    
    func setNotLoaded() {
        self.dataIsLoaded = false
    }
   
    func setLoaded() {
        self.dataIsLoaded = true
    }
   
    func filterSites(filter : [Vaccine]) -> [VaccineEntry] {
        var finalSites : [VaccineEntry] = []
        for site in self.sites {
            if (filter.contains(Vaccine.Moderna)) && (site.vaccineTypes.contains("Moderna")) {
                finalSites.append(site)
            } else {
                if (filter.contains(Vaccine.Pfizer)) && (site.vaccineTypes.contains("Pfizer")) {
                    finalSites.append(site)
                }
                else {
                    if (filter.contains(Vaccine.JJ)) && (site.vaccineTypes.contains("Johnson & Johnson")) {
                        finalSites.append(site)
                    }
                }
            }
        }
        return finalSites
    }
    
    
    func load(state : String, vaccineSelected : [Vaccine]) {

        self.dataIsLoaded = false
        var tempSites : [VaccineEntry] = []
        var numSites  : Int = 0
        print("Inside load routine....")
        print("Vaccine Selected \(vaccineSelected)")
        
        self.dataIsLoaded = false

        // check the URL String
        guard let url = URL(string: "https://www.vaccinespotter.org/api/v0/states/"+state+".json") else {
            print("Invalid URL")
            return
        }
        
        // https://www.vaccinespotter.org/api/v0/states/va.json"
        
        // launch the api request
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let error = error {
                        print("Error on URL call... \(error)")
                        return
                    }
            
            
            guard let httpResponse = response as? HTTPURLResponse,
                        (200...299).contains(httpResponse.statusCode) else {
                        print("Http response error...\(response.debugDescription)")
                        return
                    }
            
             guard let json = try? JSON(data : data!) else {
                print("returning")
                return
            }
            
            
                print("set data loaded flag to false")
                let userLocation = self.locationManager.location
        
                print("parsing has started.... --> \(self.available)")
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
                        }

                        if (properties.0 == "provider_brand_name") {
                            vaccine.provider_brand_name = properties.1.stringValue
                        }
                        
                        if (vaccine.appointments_available) {
                            var incrementFlag = true
                            if (properties.0 == "appointment_vaccine_types") {
                                for (vaccineType, vaccineFlag) in properties.1 {
                                    if (vaccineType == "jj" && vaccineFlag.boolValue) {
                                        vaccine.vaccineTypes.append("Johnson & Johnson")
                                        if (vaccineSelected.contains(Vaccine.JJ)) {
                                                numSites = numSites + 1
                                                tempSites.append(vaccine)
                                                incrementFlag = false
                                            }
                                        }
                                    
                                    if (vaccineType == "pfizer" && vaccineFlag.boolValue) {
                                        vaccine.vaccineTypes.append("Pfizer")
                                        if (vaccineSelected.contains(Vaccine.Pfizer) && (incrementFlag)) {
                                                numSites = numSites + 1
                                                tempSites.append(vaccine)
                                                incrementFlag = false
                                        }
                                        
                                    }
                                    
                                    if (vaccineType == "moderna" && vaccineFlag.boolValue) {
                                        vaccine.vaccineTypes.append("Moderna")
                                        if (vaccineSelected.contains(Vaccine.Moderna) && (incrementFlag)) {
                                            numSites = numSites + 1
                                            tempSites.append(vaccine)
                                        }
                                    }
                                } // types
                            } // available
                        } // loop on properties
                        
                       
                    } // loop on features
                    
                   
                } // URL Session block
                
                DispatchQueue.main.async {
                    print("Available -> \(self.available)")
                    print("set data loaded flag to true")
                    self.sites = tempSites
                    self.available = numSites
                    self.dataIsLoaded = true
                    print("Available -> \(self.available)")
                    print("set data loaded flag to true")
                    print("Total Sites ==> \(self.sites.count)")
                }
                
        }.resume()
        
    }
}
