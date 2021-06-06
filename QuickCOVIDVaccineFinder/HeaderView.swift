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

    var body: some View {

        Spacer()
        Text("Vaccine Sites: \(self.numberOfSites)")
        Text("Click location name for more information")
        Link("Thanks goes to the Excellent Vaccine Spotter", destination: URL(string: "https://www.vaccinespotter.org")!)
        Text("Select the vaccines you would like to see")
    
    }
}
