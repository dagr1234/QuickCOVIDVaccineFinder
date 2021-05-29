//
//  ContentView.swift
//  QuickCOVIDVaccineFinder
//
//  Created by David Grossman on 4/22/21.
//
// queries vaccinespootter.org --- built by a truly helpful person and displays result on iOS Device
//
import SwiftUI
import CoreLocation

enum Vaccine {
    case Pfizer
    case Moderna
    case JJ
}

struct ContentView: View {
    
    let NUMBER_OF_VACCINES = 3
    var locationManager = LocationManager()
    @State var allVaccineSites : [VaccineEntry] = []
    @State var numAvailable    : Int = 0
    @State var loading         : Bool = false
    @State private var isLoading = false
    @State var showSplash      : Bool = true
    @State var vaccineSelected : [Vaccine] = [Vaccine.Pfizer, Vaccine.Moderna, Vaccine.JJ]
    @State var resultList : ResultList = ResultList()
    
    // sort vaccine sites by distance from user
    func getVaccineSitesSortedByDistance(filter : [Vaccine]) -> [VaccineEntry] {
        if (filter.count == NUMBER_OF_VACCINES) {
            return allVaccineSites.sorted { $0.distanceFromUser < $1.distanceFromUser}
        }
        
        let vaccineSites = allVaccineSites.sorted { $0.distanceFromUser < $1.distanceFromUser}
        var finalSites : [VaccineEntry] = []
        for site in vaccineSites {
            if (filter.contains(Vaccine.Moderna)) && (site.vaccineTypes.contains("Moderna")) {
                finalSites.append(site)
            } else {
                if (filter.contains(Vaccine.Pfizer)) && (site.vaccineTypes.contains("Pfizer")) {
                    finalSites.append(site)
                }
                else {
                    if (filter.contains(Vaccine.JJ)) && (site.vaccineTypes.contains("Johnson & Johnson")) {
                        print("JJ")
                        finalSites.append(site)
                    }
                }
            }
            
        }
        return finalSites
    }
    
    var body: some View {
//        ZStack {
//            if (self.showSplash) {
//                SplashView()
//                    .onAppear {
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
//                                self.showSplash = false
//                        }
//                    }
//            } else {
        ZStack {
            GeometryReader { geometry in
                    ZStack {
                        VStack {
                            HStack {
                                Spacer()
                                    VStack {

                                        // header text
                                        HeaderView(numberOfSites : self.allVaccineSites.count,
                                                   numberOfAvailableSites : self.numAvailable)

                                        // buttons
                                        VaccineButtonView(vaccine : Vaccine.Moderna,
                                                          numberOfAvailableSites: self.$numAvailable,
                                                          vaccineSelected: self.$vaccineSelected)

                                        } //Vstack
                                        Text(" ")
                            }
                            .offset(x: 0, y: 20)
                            
                            Spacer()
                            
                        } //Hstack
                        .background(Colors.SpecialBlue)
                        .edgesIgnoringSafeArea(.all)
                        .frame( height: 100)
                        
                        // draw large black line //
                        Divider().background(Color.black).frame(height: 0).frame(height: 10).background(Color.black).padding(0)
                            .offset(x: 0, y: 60)
                        
                        
                        // output the list
                        if (!self.loading) {
                            ScrollView {
                                ForEach(self.getVaccineSitesSortedByDistance(filter : vaccineSelected),
                                        id: \.self)
                                  { vaccine in
                                    if (vaccine.appointments_available) {
                                        ListView(vaccine : vaccine).animation(/*@START_MENU_TOKEN@*/.easeIn/*@END_MENU_TOKEN@*/)
                                    }
                                }
                            }.offset(x: 0, y: 51)
                        }
                    } // Zstack
                
                .onAppear() {
                    let userState = locationManager.placemark?.administrativeArea ?? "VA"
                    print("State ===> \(userState)")
                    self.resultList.load(state : userState, vaccineSelected: self.vaccineSelected)
                    
                }
                .toolbar {
                    ToolbarItem(placement: .bottomBar) {
                        ZStack {
                        
                            if (!self.loading) {
                                Button(action: {
                                    let userState = locationManager.placemark?.administrativeArea ?? "VA"
                                    self.resultList.load(state : userState, vaccineSelected: self.vaccineSelected)
                            }) {
                                HStack {
                                    
                                    Image(systemName: "arrow.clockwise")
                                        //.font(.title)
                                        //.mask(Circle())
                                    Text("Refresh")
                                        .fontWeight(.semibold)
                                        //.font(.title)
                                        .clipShape(Rectangle())
                                        .mask(Rectangle())
                                        .frame(alignment: .trailing)
                                        
                                        
                                }
                                .frame(minWidth: 0, maxWidth: .infinity,alignment: .trailing)
                                .padding()
                                .foregroundColor(.black)
                                //.background(LinearGradient(gradient: Gradient(colors: [Color("DarkGreen"), Color("LightGreen")]), startPoint: .center, endPoint: .trailing))
                                .background(Colors.SpecialNyanza)
                                .cornerRadius(40)
                                .padding(.horizontal, 40)
                                .zIndex(1)
                                .clipShape(Rectangle())
                                .offset(x: 110, y: 10)
                                }
                            } else {
                                HStack{
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .black))
                                        .scaleEffect(1.5)
                                }.offset(x: 110, y: 10)

                            }
                        } // zStack
                    } // Toolbar Item
                } // Toolbar
            } // Geometry Reader
    //    } // else (not splash screen)
      } // Zstack
   } // View Body
} // Content View


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
