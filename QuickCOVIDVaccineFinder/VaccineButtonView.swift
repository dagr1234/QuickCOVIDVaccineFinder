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

    let SELECTED_COLOR     = Colors.SpecialAeroBlue
    let NOT_SELECTED_COLOR = Color.gray
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

    func getButtonText() -> String {
        switch vaccine {
            case Vaccine.JJ:
                return "JJ"
            case Vaccine.Moderna:
                return "Moderna"
            case Vaccine.Pfizer:
                return "Pfizer"
            }
    }
    
    func getButtonColor() -> Color {
        if vaccineSelected.contains(vaccine) {
            return SELECTED_COLOR
        } else {
            return NOT_SELECTED_COLOR
        }
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
                        Text(self.getButtonText())
                            .fontWeight(.semibold)
                            .clipShape(Rectangle())
                            .mask(Rectangle())
                        
                    
                    }
            }
            .frame(minWidth: 0, maxWidth: 200,alignment: .center)
            .padding()
            .foregroundColor(.black)
//            .background(Colors.SpecialNyanza)
            .background(self.getButtonColor())
            .cornerRadius(40)
            .zIndex(1)
            .clipShape(Rectangle())
            //    .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/)
            .overlay(
                            Capsule(style: .continuous)
                                .stroke(Color.black, style: StrokeStyle(lineWidth: 3))
            )
            }
    }
}
