//
//  ContentView.swift
//  Project1
//
//  Created by Dave Gumba on 2023-08-30.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    var body: some View {
        TabView {
            // Itineraries
            ItineraryListView()
                .tabItem {
                    Label("Itineraries", systemImage: "map.fill")
                }
            
            // Profile view
            AuthView()
                .tabItem {
                    Label("Account", systemImage: "person.crop.circle")
                }
            
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
