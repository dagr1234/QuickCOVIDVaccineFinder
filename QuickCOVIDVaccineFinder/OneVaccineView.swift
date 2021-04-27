//
//  OneVaccineView.swift
//  QuickCOVIDVaccineFinder
//
//  Created by David Grossman on 4/25/21.
//

import SwiftUI
import CoreLocation

struct OneVaccineView: View {
    
    @ObservedObject var locationViewModel = LocationViewModel()
    var vaccine : VaccineEntry
    
    
    func distance(latitude : Double, longitude: Double)  -> Double {
        
     
   
        let userLocation =     CLLocation(latitude :  latitude,
                                          longitude : longitude)
        
        let vaccineLocation =  CLLocation(latitude  : Double(self.vaccine.lattitude),
                                          longitude : Double(self.vaccine.longitude))
        
        
        let distanceInMeters = userLocation.distance(from: vaccineLocation)
        
        return(Double(0.000621371) * distanceInMeters)
    }
    
    var body: some View {
            
        HStack() {
            Spacer()
            VStack() {
                HStack {
                    
                    Text(String(vaccine.counter)).frame(alignment: .topLeading)
                        .offset(x: -130.0, y: 0)
                    Link(vaccine.provider_brand_name, destination: URL(string: vaccine.url)!)
                    }
                    
                    Text(vaccine.address).font(.subheadline).foregroundColor(.black)
                    
                    HStack() {
                        Text(vaccine.city + ",").font(.subheadline).foregroundColor(.blue)
                        Text(vaccine.state).font(.subheadline).foregroundColor(.blue)
                        Text(vaccine.zip_code).font(.subheadline).foregroundColor(.blue)
                    }
                    Text(String(format: "%.1f miles", self.distance(latitude : locationViewModel.userLatitude,
                                                                    longitude : locationViewModel.userLongitude)))
            }
            Spacer()
        }
        .frame( height: 85, alignment: .leading)
        //.padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
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
