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
    @State var dataIsLoaded    : Bool = false
    @State var showSplash      : Bool = true
    @State var numberOfSites   : Int  = 0
    @State var vaccineSelected : [Vaccine] = [Vaccine.Moderna]
    @EnvironmentObject var resultList: ResultList
   
    let screenWidth:CGFloat = UIScreen.main.bounds.width
    let screenHeight:CGFloat = UIScreen.main.bounds.height
    
    // sort vaccine sites by distance from user
    func getVaccineSitesSortedByDistance(filter : [Vaccine]) -> [VaccineEntry] {

//        if (filter.count == NUMBER_OF_VACCINES) {
//            return resultList.sites.sorted { $0.distanceFromUser < $1.distanceFromUser}
//        }
          var filteredSites : [VaccineEntry] = []
          filteredSites = resultList.filterSites(filter: filter)
          return filteredSites.sorted { $0.distanceFromUser < $1.distanceFromUser}
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
                                        
                                        Spacer()
                                        // header text
                                        HeaderView(numberOfSites : self.resultList.available)
                            
                                        HStack {
                                            
                                            Spacer()
                                            
                                            Text("    ")
                                            
                                            // Moderna Button
                                            VaccineButtonView(vaccine : Vaccine.Moderna,
                                                              vaccineSelected: self.$vaccineSelected)
                                               
                                            
                                    
                                            // Pfizer Button
                                            VaccineButtonView(vaccine : Vaccine.Pfizer,
                                                              vaccineSelected: self.$vaccineSelected)
                                            
                                            
                                            // JJ Button
                                            VaccineButtonView(vaccine : Vaccine.JJ,
                                                              vaccineSelected: self.$vaccineSelected)
                                            
                                            Spacer()
                                            
                                            
                                        }
                                        Spacer()
                                    }
                                             
                            }
                            .offset(x: -40, y: 5)
                            
                            // draw large black line //
                            Divider().background(Color.black).frame(height: 0).frame(height: 10).background(Color.black).padding(0)
                            
                        } //Hstack
                        .background(Colors.SpecialBlue)
                        .edgesIgnoringSafeArea(.all)
                        .frame( height: 100)
                        .offset(x: 0, y: -360)
                    
                        
                        // output the list
                        if (resultList.dataIsLoaded) {
                            ScrollView {
                                ForEach(self.getVaccineSitesSortedByDistance(filter : vaccineSelected),
                                        id: \.self)
                                  { vaccine in
                                    if (vaccine.appointments_available) {
                                        ListView(vaccine : vaccine).animation(/*@START_MENU_TOKEN@*/.easeIn/*@END_MENU_TOKEN@*/)
                                    }
                                }
                            }.offset(x: 0, y: 190)
                        }
                    } // Zstack
                
                .onAppear() {
                    let userState = locationManager.placemark?.administrativeArea ?? "VA"
                    print("State ===> \(userState)")
                    print("Loading....")
                    self.resultList.load(state : userState, vaccineSelected: self.vaccineSelected)
                    
                    
                }
                .toolbar {
                    ToolbarItem(placement: .bottomBar) {
                        ZStack {
                        
                            if (resultList.dataIsLoaded) {
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
                         //       .background(LinearGradient(gradient: Gradient(colors: [Color("DarkGreen"), Color("LightGreen")]), startPoint: .center, endPoint: .trailing))
                                .background(Colors.SpecialNyanza)
                                .cornerRadius(40)
                                .padding(.horizontal, 40)
                                .zIndex(1)
                                .clipShape(Rectangle())
                                .offset(x: 110, y: 10)
                                }
                            }
                            else {
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
}

// Content View


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
