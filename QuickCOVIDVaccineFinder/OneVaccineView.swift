//
//  OneVaccineView.swift
//  QuickCOVIDVaccineFinder
//
//  Created by David Grossman on 4/25/21.
//

import SwiftUI
import CoreLocation

struct Title: ViewModifier {
    func body(content: Content) -> some View {
        content
              .font(.headline)
//            .foregroundColor(.white)
//            .padding()
//            .background(Color.blue)
//            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

struct OneVaccineView: View {
    
    var vaccine : VaccineEntry
    
    var body: some View {
            
        HStack() {
            Spacer()
                VStack() {
           
//                    Text(String(vaccine.counter)).frame(alignment: .topLeading)
//                        .offset(x: -130.0, y: 0)
                    
                    if (vaccine.url.count > 0 && vaccine.provider_brand_name.count > 0) {
                        Link(vaccine.provider_brand_name, destination: URL(string: vaccine.url)!).modifier(Title())
                    } else {
                        if (vaccine.provider_brand_name.count > 0) {
                            Text(vaccine.provider_brand_name).font(.headline).foregroundColor(.black)
                        }
                    }
                    
                    if (vaccine.address.count > 0) {
                        Text(vaccine.address.capitalized).font(.subheadline).foregroundColor(.black)
                    }
                        
                    HStack() {
                        Text(vaccine.city.capitalized + ",").font(.subheadline).foregroundColor(.black)
                        Text(vaccine.state).font(.subheadline).foregroundColor(.black)
                        Text(vaccine.zip_code).font(.subheadline).foregroundColor(.black)
                    }
                 
                // list of vaccines
                    HStack() {
                        ForEach( vaccine.vaccineTypes, id : \.self) { vaccineType  in
                            Text(vaccineType + " ")
                        }
                    }
                    
                    Text(String(format: "%.1f miles", vaccine.distanceFromUser))
            }
            Spacer()
        }
        .frame( height: 120, alignment: .leading)
        .background(Colors.SpecialAeroBlue
                        .cornerRadius(/*@START_MENU_TOKEN@*/11.0/*@END_MENU_TOKEN@*/))

    }
}


struct OneVaccineView_Previews: PreviewProvider {
    static var previews: some View {
        OneVaccineView(vaccine : VaccineEntry(id: 1, url: "www.grossmanlabs.com", provider: "test provider",
                                              city: "New York", state: "NY", zipCode: "12345", address: "01 North Pole Drive", name: "Santa",
                                              longitude : 10.0, lattitude: 10.0))
          
    }
}
