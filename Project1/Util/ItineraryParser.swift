//
//  ChatResponseParser.swift
//  Project1
//
//  Created by Dave Gumba on 2023-09-08.
//

import Foundation
import SwiftSoup

struct ChatResponse {
    
    // Highlighted places from response. Each index represents a day
    var places: [[String]]
    
    // each index represents a day
    var activities: [[String]]
    
    // For the viewmodel to display the itinerary to the view
    var responseToDisplay: [[String]]?
    
    // For storing into Firebase
    // Do we need this?
    var parsedResponse: [String]
}

struct ItineraryParser {
    
    private static let dayDelimiter = "!@#$%^&*"
    
    static func parseResponseFromOpenAI(rawResponse: String) async -> ChatResponse {
        let parsedResponse = rawResponse
            .components(separatedBy: dayDelimiter)
            .filter({ !$0.isEmpty })
        do {
            let places = try await extractCustomTags(arrayedResponse: parsedResponse, customTag: "place")
            let activities = try await extractCustomTags(arrayedResponse: parsedResponse, customTag: "activity")
            return ChatResponse(places: places, activities: activities, parsedResponse: parsedResponse)
        } catch {
            print("Error from parseResponse")
            return ChatResponse(places: [], activities: [], parsedResponse: [""])
        }
        
    }
    
    // Get an array of things between certain tags.
    private static func extractCustomTags(arrayedResponse: [String], customTag: String) async throws -> [[String]] {
        var items: [[String]] = Array(repeating: [], count: arrayedResponse.count)
        for (day, plan) in arrayedResponse.enumerated() {
            let doc = try SwiftSoup.parse(plan)
            let taggedItems = try doc.select(customTag)
            
            for activity in taggedItems.array() {
                items[day].append(try activity.text())
            }
            
        }
        return items
    }
}
