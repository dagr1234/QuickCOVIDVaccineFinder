//
//  ListView.swift
//  QuickCOVIDVaccineFinder
//
//  Created by David Grossman on 4/25/21.
//

import SwiftUI

struct ListView: View {
    
       var vaccine : VaccineEntry
    
        var body: some View {
            // you won't get the width of the container if you embed this view inside a horizontal scroll view which is the case for you
            // so you have to impose the explicit width from the parent view
         //  ScrollView(.vertical) {
            VStack(spacing: 10) { //THIS SPACING PARAMETER DOES NOTHING
                    OneVaccineView(vaccine : vaccine)
            }
               .padding(4) //use this to change the space bettween the entries
           // }
        }
}


struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView(vaccine : VaccineEntry())
    }
}
