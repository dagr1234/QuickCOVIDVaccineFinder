//
//  VaccineEntry.swift
//  QuickCOVIDVaccineFinder
//
//  Created by David Grossman on 4/22/21.
//

import Foundation

struct VaccineEntry : Decodable, Hashable  {
    var id                     :   Int // Vaccine Spotter's own unique ID for this location.
    var url                    :   String
    var provider               :   String // A unique key representing the pharmacy or provider this location belongs to.
    var city                   :   String
    var zip_code               :   String
    var address                :   String
    var state                  :   String
    var name                   :   String
    var provider_brand_name    :   String
    var appointments_available : Bool  //value as to whether or not appointments are currently available at this location as of last check.
    var location_type          :   String
    var lattitude              :   Float = 0.0
    var longitude              :   Float = 0.0
    var distanceFromUser       :   Double = 0.0
    var vaccineTypes           :   [String]
    
    init() {
        self.id = 0
        self.url = ""
        self.provider = ""
        self.appointments_available = false
        self.city = ""
        self.zip_code = ""
        self.address = ""
        self.name = ""
        self.state = ""
        self.provider_brand_name = ""
        self.location_type = ""
        self.lattitude = 0.0
        self.longitude = 0.0
        self.distanceFromUser = 0.0
        self.vaccineTypes = []
    }
    
    init (id : Int, url : String, provider : String, city : String, state : String, zipCode : String, address : String, name : String,
          longitude : Float, lattitude : Float ) {
        self.id = 0
        self.url = url
        self.provider = provider
        self.appointments_available = false
        self.city = city
        self.zip_code = zipCode
        self.address = address
        self.name = name
        self.state = state
        self.provider_brand_name = "CVS"
        self.location_type = "Point"
        self.distanceFromUser = 0.0
        self.vaccineTypes = []
    }
}


