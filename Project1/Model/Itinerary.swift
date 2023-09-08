//
//  Itinerary.swift
//  Project1
//
//  Created by Dave Gumba on 2023-09-07.
//

import Foundation
import FirebaseFirestoreSwift
import Firebase

struct Itinerary: Identifiable, Codable {
    @DocumentID var itineraryId: String?
    let ownerUid: String
    let country: String
    let city: String
    let numberOfDays: Int
    let details: [String]
    let timestamp: Timestamp
    
    var id: String {
        return itineraryId ?? NSUUID().uuidString
    }
    
    var user: User?
}

// This is so we can iterate through detils
extension String: Identifiable {
    public typealias ID = Int
    public var id: Int {
        return hash
    }
}
