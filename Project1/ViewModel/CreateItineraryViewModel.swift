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
        
        let itinerary = Itinerary(ownerUid: uid, numberOfDays: 0, timestamp: Timestamp(), details: [["", ""], ["", ""]])
        try await ItineraryService.uploadItinerary(itinerary)
    }
}
