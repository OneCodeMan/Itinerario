//
//  ChatResponseParser.swift
//  Project1
//
//  Created by Dave Gumba on 2023-09-08.
//

import Foundation

struct ChatResponseParser {
    
    private static let dayDelimiter = "!@#$%^&*"
    
    static func parseResponse(rawResponse: String) -> [String] {
        let parsedResponse = rawResponse.components(separatedBy: dayDelimiter)
        return parsedResponse
    }
    
}
