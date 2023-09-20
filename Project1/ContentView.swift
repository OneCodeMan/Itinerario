//
//  ContentView.swift
//  Project1
//
//  Created by Dave Gumba on 2023-08-30.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @State private var tabSelection = 1
    
    var body: some View {
        TabView(selection: $tabSelection) {
            // Itineraries
            ItineraryListView(tabSelection: $tabSelection)
                .tabItem {
                    Label("Itineraries", systemImage: "map.fill")
                }
                .tag(1)
            
            // Profile view
            AuthView()
                .tabItem {
                    Label("Account", systemImage: "person.crop.circle")
                }
                .tag(2)
            
            // Test view
//            TestView()
//                .tabItem {
//                    Label("TEST", systemImage: "gear")
//                }
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
