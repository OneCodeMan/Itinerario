//
//  ItineraryService.swift
//  Project1
//
//  Created by Dave Gumba on 2023-09-07.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

struct ItineraryService {
    
    static func uploadItinerary(_ itinerary: Itinerary) async throws {
        guard let itineraryData = try? Firestore.Encoder().encode(itinerary) else { return }
        try await Firestore.firestore().collection("itineraries").addDocument(data: itineraryData)
    }
    
    static func fetchItineraries() async throws -> [Itinerary] {
        let snapshot = try await Firestore.firestore().collection("itineraries").order(by: "timestamp", descending: true).getDocuments()
        
        let documents = snapshot.documents.compactMap({ try? $0.data(as: Itinerary.self) })
        
        return documents
    }
    
}
