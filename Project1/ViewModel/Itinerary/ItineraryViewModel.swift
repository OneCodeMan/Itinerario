//
//  ItineraryViewModel.swift
//  Project1
//
//  Created by Dave Gumba on 2023-09-07.
//

import Foundation

class ItineraryViewModel: ObservableObject {
    @Published var itineraries = [ItineraryDisplay]()
    
    init() {
        Task { try await fetchItineraries() }
    }
    
    @MainActor
    func fetchItineraries() async throws {
        let fetchedItineraries = try await ItineraryService.fetchItineraries()
        self.itineraries = await ItineraryParser.parseResponseFromFirebase(itineraries: fetchedItineraries)
    }
}
