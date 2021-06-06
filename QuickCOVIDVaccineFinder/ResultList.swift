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

        print("Starting to load....")
        print("Vaccine Selected \(vaccineSelected)")
        

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
             guard let json = try? JSON(data : data!) else {
                print("returning")
                return
            }
            
            DispatchQueue.main.sync {
                self.sites = []
                self.dataIsLoaded = false
                self.available = 0
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
                            if (vaccine.appointments_available) {
                                if (vaccineSelected.count == self.NUMBER_OF_VACCINES) {
                                    self.available = self.available + 1
                                }
                            }
                        }

                        if (properties.0 == "provider_brand_name") {
                            vaccine.provider_brand_name = properties.1.stringValue
                        }
                        
                        var incrementFlag = true
                        if (properties.0 == "appointment_vaccine_types") {
                            for (vaccineType, vaccineFlag) in properties.1 {
                                if (vaccineType == "jj" && vaccineFlag.boolValue) {
                                    vaccine.vaccineTypes.append("Johnson & Johnson")
                                    if (vaccineSelected.contains(Vaccine.JJ)) {
                                        self.available = self.available + 1
                                        self.sites.append(vaccine)
                                        incrementFlag = false
                                    }
                                }
                                if (vaccineType == "pfizer" && vaccineFlag.boolValue) {
                                    vaccine.vaccineTypes.append("Pfizer")
                                    if (vaccineSelected.contains(Vaccine.Pfizer) && (incrementFlag)) {
                                        self.available = self.available + 1
                                        self.sites.append(vaccine)
                                        incrementFlag = false
                                    }
                                    
                                }
                                if (vaccineType == "moderna" && vaccineFlag.boolValue) {
                                    vaccine.vaccineTypes.append("Moderna")
                                    if (vaccineSelected.contains(Vaccine.Moderna) && (incrementFlag)) {
                                        self.available = self.available + 1
                                        self.sites.append(vaccine)
                                    }
                                }
                            }
                        }
                        
                       
                    }
                    
                   
                }
                print("Available -> \(self.available)")
                
                self.dataIsLoaded = true
                print("Total Sites ==> \(self.sites.count)")
            }
                
        }.resume()
        
    }
}
