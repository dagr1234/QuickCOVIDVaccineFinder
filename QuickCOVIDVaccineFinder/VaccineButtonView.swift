//
//  VaccineButtonView.swift
//  QuickCOVIDVaccineFinder
//
//  Created by David Grossman on 5/28/21.
//

import Foundation
import SwiftUI
import CoreLocation


struct VaccineButtonView: View {

    var vaccine : Vaccine
    @Binding var numberOfAvailableSites : Int
    var locationManager : LocationManager = LocationManager()
    @Binding var vaccineSelected : [Vaccine]

    // remove a vaccine from the list of selected vaccines
    func removeVaccine(vaccineToRemove : Vaccine) {
        var result : [Vaccine] = []
        for current in self.vaccineSelected {
            if (current != vaccineToRemove) {
                result.append(current)
            }
        }
        self.vaccineSelected = result
    }

    
    var body: some View {

            HStack {
                // Moderna Button
                Button(action: {
                    let userState = locationManager.placemark?.administrativeArea ?? "VA"
                    
                    if (self.vaccineSelected.contains(vaccine)) {
                        self.removeVaccine(vaccineToRemove : vaccine)
                    } else {
                        self.vaccineSelected.append(vaccine)
                    }
                    let resultList : ResultList = ResultList()
                    resultList.load(state : userState, vaccineSelected: self.vaccineSelected)
                }) {
                    HStack {
                        Text("Moderna")
                            .fontWeight(.semibold)
                            .clipShape(Rectangle())
                            .mask(Rectangle())
                        
                    
                    }
            }
            .frame(minWidth: 0, maxWidth: 200,alignment: .center)
            .padding()
            .foregroundColor(.black)
            .background(Colors.SpecialNyanza)
            .cornerRadius(40)
            .zIndex(1)
            .clipShape(Rectangle())
        }
    }
}
