//
//  OneVaccineView.swift
//  QuickCOVIDVaccineFinder
//
//  Created by David Grossman on 4/25/21.
//

import SwiftUI

struct OneVaccineView: View {
    
    var vaccine : VaccineEntry
    
    var body: some View {
            
        VStack(alignment: .leading) {
            Text(vaccine.provider_brand_name).font(.subheadline).foregroundColor(.black)
            Text(vaccine.address).font(.subheadline).foregroundColor(.black)
            HStack(alignment: .top) {
                Text(vaccine.city + ",").font(.subheadline).foregroundColor(.blue)
                Text(vaccine.state).font(.subheadline).foregroundColor(.blue)
                Text(vaccine.zip_code).font(.subheadline).foregroundColor(.blue)
//                Text(String(vaccine.lattitude)).font(.subheadline).foregroundColor(.black)
//                Text(String(vaccine.longitude)).font(.subheadline).foregroundColor(.black)
            }

        }
        .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                
                
                //Spacer()
//                Text(String(format: "%.1f miles", trail.distance))
    }
}


struct OneVaccineView_Previews: PreviewProvider {
    static var previews: some View {
        OneVaccineView(vaccine : VaccineEntry(id: 1, url: "www.grossmanlabs.com", provider: "test provider",
                                              city: "New York", state: "NY", zipCode: "12345", address: "01 North Pole Drive", name: "Santa",
                                              longitude : 10.0, lattitude: 10.0))
          
    }
}
