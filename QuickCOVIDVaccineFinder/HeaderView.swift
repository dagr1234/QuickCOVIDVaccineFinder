//
//  HeaderView.swift
//  QuickCOVIDVaccineFinder
//
//  Created by David Grossman on 5/27/21.
//

import Foundation

import SwiftUI

struct HeaderView: View {
    
    var numberOfSites          : Int
    var numberOfAvailableSites : Int
    
    var body: some View {

        Text(" ")
        Text(" ")
        Text("Available Vaccines: ").font(.custom("Colonna MT Regular", size: 25))
            //.font(.headline)
        Text("Total Locations: \(self.numberOfSites)")
        Text("Number Available with Vaccine: \(self.numberOfAvailableSites)")
        Text("Click location name for more information")
        Link("Thanks goes to the Excellent Vaccine Spotter", destination: URL(string: "https://www.vaccinespotter.org")!)
        Text("Select the vaccines you would like to see")
    }
}
