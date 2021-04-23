//
//  ContentView.swift
//  QuickCOVIDVaccineFinder
//
//  Created by David Grossman on 4/22/21.
//

import SwiftUI



struct ContentView: View {
    
    @State var results = [VaccineEntry]()
    
    
    func loadData() {
            guard let url = URL(string: "https://www.vaccinespotter.org/api/v0/states/VA.json") else {
                print("Invalid URL")
                return
            }
            let request = URLRequest(url: url)

            URLSession.shared.dataTask(with: request) { data, response, error in
                if let data = data {
                    if let response = try? JSONDecoder().decode([VaccineEntry].self, from: data) {
                        DispatchQueue.main.async {
                            self.results = response
                        }
                        return
                    }
                }
            }.resume()
        }
    
    
    
    var body: some View {
        List(results, id: \.id) { item in
                    VStack(alignment: .leading) {
                        Text(item.title)
                    }
                }.onAppear(perform: loadData)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
