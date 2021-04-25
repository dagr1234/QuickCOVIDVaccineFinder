//
//  VaccineEntry.swift
//  QuickCOVIDVaccineFinder
//
//  Created by David Grossman on 4/22/21.
//

import Foundation

struct VaccineEntry : Decodable  {
    var id:                   Int // Vaccine Spotter's own unique ID for this location.
    var url      :            String
    var provider :            String // A unique key representing the pharmacy or provider this location belongs to.
    var city     :            String
    var zip_code :            String
    var address  :            String
    var state    :            String
    var name     :            String
    var appointments_available: Bool  //value as to whether or not appointments are currently available at this location as of last check.
    
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
    }
}

struct VaccineEntries: Decodable {
  var results: [VaccineEntry]
}


