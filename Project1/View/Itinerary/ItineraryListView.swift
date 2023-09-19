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
    
    @State private var toast: Toast? = nil
    
    @State private var searchText: String = ""
    
    var body: some View {
        NavigationStack {
            
            let userSignedIn = authViewModel.userSession != nil
            
            // Toolbars
            
            // There's gotta be a better way to do nav titles and toolbars... wtf
            Text("")
                .navigationTitle("Your Itineraries")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        
                        if userSignedIn {
                            Button("New Itinerary") {
                                displayCreateItinerarySheet.toggle()
                            }
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
                if userSignedIn {
                    if itineraryViewModel.itineraryDisplays.isEmpty {
                        EmptyItineraryView()
                    } else {
                        List(itineraryViewModel.filteredItineraryDisplays, id: \.self) { itinerary in
                            NavigationLink(destination: ItineraryDetailView(itinerary: itinerary)) {
                                ItineraryRowView(itinerary: itinerary)
                                    .swipeActions {
                                        Button(role: .destructive) {
                                            self.itineraryViewModel.deleteItinerary(withID: itinerary.documentID)
                                            toast = Toast(type: .info, title: "Itinerary Deleted", message: "")
                                        } label: {
                                            Label("Delete", systemImage: "trash.fill")
                                        }
                                    }
                            }
                        }
                        .scrollContentBackground(.hidden)
                        .listStyle(InsetListStyle())
                        .toastView(toast: $toast)
                        .searchable(text: $searchText)
                        .onChange(of: searchText) { search in
                            if !search.isEmpty {
                                self.itineraryViewModel.filterItineraries(term: search)
                            } else {
                                self.itineraryViewModel.resetFilteredItineraries()
                            }
                        }
                    }
                } else {
                    EmptyItineraryView()
                }
            } else {
                CustomLoadingView(text: "Loading itineraries")
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
