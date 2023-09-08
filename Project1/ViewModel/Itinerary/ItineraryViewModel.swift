//
//  ItineraryViewModel.swift
//  Project1
//
//  Created by Dave Gumba on 2023-09-07.
//

import Foundation

class ItineraryViewModel: ObservableObject {
    @Published var itineraries = [Itinerary]()
    
    init() {
        Task { try await fetchItineraries() }
    }
    
    @MainActor
    func fetchItineraries() async throws {
        self.itineraries = try await ItineraryService.fetchItineraries()
    }
}
