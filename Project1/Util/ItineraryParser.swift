//
//  ChatResponseParser.swift
//  Project1
//
//  Created by Dave Gumba on 2023-09-08.
//

import Foundation
import UIKit
import SwiftSoup
import SwiftUI
import Firebase

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
    
    var highlightedActivities: [[AttributedString]]
}

struct ItineraryDisplay: Identifiable, Hashable {
    let id = UUID()
    
    let documentID: String

    var city: String
    var country: String = ""
    var numberOfDays: Int
    
    var places: [[String]]
    var activities: [[String]]
    var activitiesWithHighlightedPlaces: [[AttributedString]]
    
    var timestamp: Timestamp
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
            let activitiesWithHighlightedPlaces = highlightPlaces(placesToBold: places, sentences: activities)
            return ChatResponse(places: places, activities: activities, parsedResponse: parsedResponse, highlightedActivities: activitiesWithHighlightedPlaces)
        } catch {
            print("Error from parseResponse")
            return ChatResponse(places: [], activities: [], parsedResponse: [""], highlightedActivities: [])
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
    
    static func parseResponseFromFirebase(itineraries: [Itinerary]) async -> [ItineraryDisplay] {
        var itineraryDisplays = [ItineraryDisplay]()
        do {
            for itinerary in itineraries {
                let places = try await extractCustomTags(arrayedResponse: itinerary.details, customTag: placeTag)
                let activities = try await extractCustomTags(arrayedResponse: itinerary.details, customTag: activityTag)
                let activitiesWithHighlightedPlaces = highlightPlaces(placesToBold: places, sentences: activities)
                let itineraryDisplay = ItineraryDisplay(documentID: itinerary.itineraryId ?? "", city: itinerary.city, numberOfDays: itinerary.numberOfDays, places: places, activities: activities, activitiesWithHighlightedPlaces: activitiesWithHighlightedPlaces, timestamp: itinerary.timestamp)
                itineraryDisplays.append(itineraryDisplay)
            }
        } catch {
            print("ERROR FROM ITINERARYPARSER.parseResponseFromFirebase: \(error.localizedDescription)")
        }
        
        return itineraryDisplays
    }
    
    // Return a bunch of activities as NSMutableStrings, each place bolded
    static func highlightPlaces(placesToBold: [[String]], sentences: [[String]]) -> [[AttributedString]] {
        var activitiesWithHighlightsForAllDays = [[AttributedString]]()
        let allPlacesToBoldFlattened = placesToBold.reduce([], +)
        
        // for every sentence in sentences
        // check if each place in placesToBold is in that sentence
        // if so.. add an attribute
        
        for sentenceGroup in sentences {
            var dailyActivitiesWithHighlights = [AttributedString]()
            for sentence in sentenceGroup {
                var attributedActivity = AttributedString(sentence)
                
                for word in allPlacesToBoldFlattened {
                    if let range = attributedActivity.range(of: word) {
                        attributedActivity[range].foregroundColor = Color.blue
                    }
                }
                dailyActivitiesWithHighlights.append(attributedActivity)
            }
            activitiesWithHighlightsForAllDays.append(dailyActivitiesWithHighlights)
        }
        
        return activitiesWithHighlightsForAllDays
    }
}
