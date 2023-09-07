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
    let numberOfDays: Int
    let timestamp: Timestamp
    let details: [[String]]
    
    var id: String {
        return itineraryId ?? NSUUID().uuidString
    }
    
    var user: User?
}
