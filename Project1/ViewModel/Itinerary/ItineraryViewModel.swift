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
        isLoading = false
    }
    
    func deleteItinerary(withID id: String) {
        ItineraryService.deleteItinerary(withID: id)
    }
}
