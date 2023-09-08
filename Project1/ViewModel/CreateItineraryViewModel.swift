//
//  CreateItineraryViewModel.swift
//  Project1
//
//  Created by Dave Gumba on 2023-09-07.
//

import Firebase

class CreateItineraryViewModel: ObservableObject {
    
    func uploadItinerary() async throws {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let itinerary = Itinerary(ownerUid: uid, country: "Slovenia", city: "Ljubljana", numberOfDays: 3, details: ["Day 1", "Day 2", "Day 3"], timestamp: Timestamp())
        try await ItineraryService.uploadItinerary(itinerary)
    }
}

extension CreateItineraryViewModel {
    
    func uploadMockItinerary() async throws {
        if let itinerary = mockItinerary3() {
            try await ItineraryService.uploadItinerary(itinerary)
        }
    }
    
    func mockItinerary1() -> Itinerary? {
        guard let uid = Auth.auth().currentUser?.uid else { return nil }
        return Itinerary(ownerUid: uid, country: "Italy", city: "Florence", numberOfDays: 4, details: ["Day 1 you do this", "Day 2 you do that", "Day 3 you do this & that", "Day 4 is a rest day", "Day 5 is a good time."], timestamp: Timestamp())
    }

    func mockItinerary2() -> Itinerary? {
        guard let uid = Auth.auth().currentUser?.uid else { return nil }
        return Itinerary(ownerUid: uid, country: "Germany", city: "Trier", numberOfDays: 3, details: ["Day 1 you do this", "Day 2 you do that", "Day 3 you do this & that"], timestamp: Timestamp())
    }
    
    func mockItinerary3() -> Itinerary? {
        guard let uid = Auth.auth().currentUser?.uid else { return nil }
        return Itinerary(ownerUid: uid, country: "France", city: "Paris", numberOfDays: 4, details: ["Day 1 you do this", "Day 2 you do that", "Day 3 you do this & that", "Day 4 you do nothing"], timestamp: Timestamp())
    }
}
