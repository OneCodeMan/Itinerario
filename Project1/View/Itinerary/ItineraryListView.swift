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
    
    @State var displayCreateItinerarySheet = false
    
    var body: some View {
        NavigationStack {
            
            // Toolbars
            
            // There's gotta be a better way to do nav titles and toolbars... wtf
            Text("")
                .navigationTitle("Your Itineraries")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        
                        Button("New Itinerary") {
                            displayCreateItinerarySheet.toggle()
                        }
                    }
                }
                .sheet(isPresented: $displayCreateItinerarySheet, onDismiss: {
                    Task { try await self.itineraryViewModel.fetchItineraries() }
                }) {
                    CreateItineraryView()
                }
            
            // Actual view..
            
            if !itineraryViewModel.isLoading {
                let userSignedIn = authViewModel.userSession != nil
                if userSignedIn {
                    if itineraryViewModel.itineraryDisplays.isEmpty {
                        EmptyItineraryView()
                    } else {
                        List(itineraryViewModel.itineraryDisplays, id: \.self) { itinerary in
                            NavigationLink(destination: ItineraryDetailView(itinerary: itinerary)) {
                                ItineraryRowView(itinerary: itinerary)
                                    .swipeActions {
                                        Button(role: .destructive) {
                                            self.itineraryViewModel.deleteItinerary(withID: itinerary.documentID)
                                        } label: {
                                            Label("Delete", systemImage: "trash.fill")
                                        }
                                    }
                            }
                        }
                        .scrollContentBackground(.hidden)
                        .listStyle(InsetListStyle())
                    }
                } else {
                    EmptyItineraryView()
                }
            } else {
                ProgressView("Loading itineraries")
            }
            
        }
        .onAppear {
            Task { try await self.itineraryViewModel.fetchItineraries() }
        }
    }
}

struct ItineraryListView_Previews: PreviewProvider {
    static var previews: some View {
        ItineraryListView()
    }
}
