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

struct ItineraryDisplay: Identifiable {
    let id = UUID()

    var city: String
    var country: String = ""
    var numberOfDays: Int
    
    var places: [[String]]
    var activities: [[String]]
}

struct ItineraryParser {
    
    private static let dayDelimiter = "!@#$%^&*"
    private static let placeTag = "place"
    private static let activityTag = "activity"
    
    static func parseResponseFromOpenAI(rawResponse: String) async -> ChatResponse {
        let parsedResponse = rawResponse
            .components(separatedBy: dayDelimiter)
            .filter({ !$0.isEmpty })
        do {
            let places = try await extractCustomTags(arrayedResponse: parsedResponse, customTag: placeTag)
            let activities = try await extractCustomTags(arrayedResponse: parsedResponse, customTag: activityTag)
            return ChatResponse(places: places, activities: activities, parsedResponse: parsedResponse)
        } catch {
            print("Error from parseResponse")
            return ChatResponse(places: [], activities: [], parsedResponse: [""])
        }
        
    }
    
    static func parseResponseFromFirebase(itineraries: [Itinerary]) async -> [ItineraryDisplay] {
        var itineraryDisplays = [ItineraryDisplay]()
        do {
            for itinerary in itineraries {
                let places = try await extractCustomTags(arrayedResponse: itinerary.details, customTag: placeTag)
                let activities = try await extractCustomTags(arrayedResponse: itinerary.details, customTag: activityTag)
                let itineraryDisplay = ItineraryDisplay(city: itinerary.city, numberOfDays: itinerary.numberOfDays, places: places, activities: activities)
                itineraryDisplays.append(itineraryDisplay)
            }
        } catch {
            print(error.localizedDescription)
        }
        
        return itineraryDisplays
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
