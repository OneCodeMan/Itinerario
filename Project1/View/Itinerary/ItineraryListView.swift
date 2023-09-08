//
//  ItineraryListView.swift
//  Project1
//
//  Created by Dave Gumba on 2023-09-08.
//

import SwiftUI

struct ItineraryListView: View {
    @StateObject var itineraryViewModel = ItineraryViewModel()
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        NavigationStack {
            Text("")
                .navigationTitle("Your Itineraries")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        NavigationLink(destination: CreateItineraryView()) {
                            Text("New Element")
                        }
                    }
                }
            
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 10) {
                    let userSignedIn = authViewModel.userSession != nil
                    if userSignedIn {
                        if itineraryViewModel.itineraries.isEmpty {
                            EmptyItineraryView()
                        } else {
                            ForEach(itineraryViewModel.itineraries) { itinerary in
                                NavigationLink(destination: ItineraryDetailView(itinerary: itinerary)) {
                                    ItineraryRowView(itinerary: itinerary)
                                }
                                
                            }
                        }
                    } else {
                        EmptyItineraryView()
                    }
                }
                .padding()
            }
        }
    }
}

struct ItineraryListView_Previews: PreviewProvider {
    static var previews: some View {
        ItineraryListView()
    }
}
