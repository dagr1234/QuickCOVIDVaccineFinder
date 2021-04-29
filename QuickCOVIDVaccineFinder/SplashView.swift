//
//  SpashView.swift
//  LearnHebrewNow
//
//  Created by David Grossman on 11/8/20.
//  Copyright © 2020 David Grossman. All rights reserved.
//

import SwiftUI

struct SplashView: View {
    @State private var half = false
    @State private var dim = false
    @State private var scale : CGFloat = 0.5
    @State private var showSecondImage = false
    
    var body: some View {
        ZStack (alignment : .top) {
            Spacer()
            HStack (alignment : .top, spacing: 0.0) {
                Spacer()
                VStack(alignment: .center, spacing: 12.0) {
                    Text("Quick COVID Vaccine Finder").font(.title)
                    Text("Find a vaccine near you quickly!").font(.title2)
//                        .animation(
//                            Animation.easeInOut(duration: 1)
//                                .repeatCount(3, autoreverses: false)
//                        ) //TEST THIS CODE TO SEE IF YOU LIKE TI
                    
                    Text("The data is constantly changing.")
                    Text("Please confirm with a vaccine site")
                    Text("We are just trying to help!").font(.subheadline)
                        .edgesIgnoringSafeArea(.all)
                        .background(Colors.SpecialBlue)
                Spacer()
                }.offset(x: 0, y: 300)
                Spacer()
            }
            .padding(.bottom, 44.0)
            .padding(.top, 44)
                    .onAppear() {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.50) {
                        self.showSecondImage = true
                    }
                }

            if (self.showSecondImage) {
                Image("syringe-with-medication")
                    .scaleEffect(0.50)
                    .transition(AnyTransition.move(edge: .top))
                    .animation(.easeIn)
                    .offset(y: 450)
                
                
                    
            Spacer()
//                     .transition(AnyTransition.opacity.animation(.easeInOut(duration: 1.0)))
            }
                
             Spacer()
           }
           .edgesIgnoringSafeArea(.all)
           .background(Colors.SpecialBlue)
           .edgesIgnoringSafeArea(.all)
        Spacer()
        }
}


struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}
