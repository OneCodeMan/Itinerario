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

struct ChatResponseParser {
    
    private static let dayDelimiter = "!@#$%^&*"
    
    static func parseResponse(rawResponse: String) async -> ChatResponse {
        let parsedResponse = rawResponse
            .components(separatedBy: dayDelimiter)
            .filter({ !$0.isEmpty })
        do {
            let places = try await extractPlaces(arrayedResponse: parsedResponse)
            let activities = try await extractActivities(arrayedResponse: parsedResponse)
            return ChatResponse(places: places, activities: activities, parsedResponse: parsedResponse)
        } catch {
            print("Error from parseResponse")
            return ChatResponse(places: [], activities: [], parsedResponse: [""])
        }
        
    }
    
    // TODO: refactor
    private static func extractActivities(arrayedResponse: [String]) async throws -> [[String]] {
        var days: [[String]] = Array(repeating: [], count: arrayedResponse.count)
        for (day, plan) in arrayedResponse.enumerated() {
            let doc = try SwiftSoup.parse(plan)
            let taggedActivities = try doc.select("activity")
            
            for activity in taggedActivities.array() {
                days[day].append(try activity.text())
            }
            
        }
        return days
    }
    
    // Get an array of places for each day of the trip.
    // TODO: refactor
    private static func extractPlaces(arrayedResponse: [String]) async throws -> [[String]]  {
        var places: [[String]] = Array(repeating: [], count: arrayedResponse.count)
        for (day, plan) in arrayedResponse.enumerated() {
            let doc = try SwiftSoup.parse(plan)
            let taggedPlaces = try doc.select("place")
            
            for place in taggedPlaces.array() {
                places[day].append(try place.text())
            }
        }
        
        return places
    }
}
