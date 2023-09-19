//
//  ItineraryViewModel.swift
//  Project1
//
//  Created by Dave Gumba on 2023-09-07.
//

import Foundation

class ItineraryViewModel: ObservableObject {
    private var itineraries = [Itinerary]()
    @Published var itineraryDisplays = [ItineraryDisplay]()
    @Published var filteredItineraryDisplays = [ItineraryDisplay]()
    @Published var isLoading = false
    
    init() {
        Task { try await fetchItineraries() }
    }
    
    @MainActor
    func fetchItineraries() async throws {
        isLoading = true
        let fetchedItineraries = try await ItineraryService.fetchItineraries()
        self.itineraries = fetchedItineraries
        self.itineraryDisplays = await ItineraryParser.parseResponseFromFirebase(itineraries: fetchedItineraries)
        self.filteredItineraryDisplays = self.itineraryDisplays
        isLoading = false
    }
    
    func deleteItinerary(withID id: String) {
        ItineraryService.deleteItinerary(withID: id)
    }
    
    func filterItineraries(term: String) {
        isLoading = true
        self.filteredItineraryDisplays = self.itineraryDisplays.filter{ $0.city.contains(term) }
        isLoading = false
    }
    
    func resetFilteredItineraries() {
        isLoading = true
        self.filteredItineraryDisplays = self.itineraryDisplays
        isLoading = false
    }
}
