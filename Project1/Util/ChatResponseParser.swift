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
            return ChatResponse(places: places, parsedResponse: parsedResponse)
        } catch {
            print("Error from parseResponse")
            return ChatResponse(places: [], parsedResponse: [""])
        }
        
    }
    
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
    
//    func parseCustomTags(htmlString: String, customTagName: String) {
//        do {
//            let doc = try SwiftSoup.parse(htmlString)
//
//            // Extract and print content from custom tags
//            let customTags = try doc.select(customTagName)
//            for customTag in customTags.array() {
//                print("Custom Tag (\(customTagName)): \(try customTag.text())")
//            }
//        } catch let error {
//            print("Error parsing HTML: \(error.localizedDescription)")
//        }
//    }
}
