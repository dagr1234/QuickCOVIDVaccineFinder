//
//  QuickCOVIDVaccineFinderApp.swift
//  QuickCOVIDVaccineFinder
//
//  Created by David Grossman on 4/22/21.
//
import SwiftUI

@main
struct QuickCOVIDVaccineFinderApp: App {
    
    @StateObject var resultList : ResultList = ResultList()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(resultList)
        }
    }
}
