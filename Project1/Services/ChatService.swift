//
//  ChatService.swift
//  Project1
//
//  Created by Dave Gumba on 2023-08-31.
//

import Foundation
import ChatGPTSwift

struct ChatService {
    
    // Function to call ChatGPT here
    static func getChatData(message: String) async throws -> String {
        do {
            let api = ChatGPTAPI(apiKey: getAPIKey())
            
            let response = try await api.sendMessage(text: message,
                                                     model: "gpt-3.5-turbo")
            print("ChatService: Here is the chat data response: \n\n\n\n")
            print(response)
            print("\n\n\n\n")
            return response
        } catch {
            print("ERROR FROM CHATSERVICE.GETCHATDATA: \(error.localizedDescription)")
        }
            
        return ""
    }
    
    static private func getAPIKey() -> String {
        var keys: NSDictionary?
        if let path = Bundle.main.path(forResource: "Keys", ofType: "plist") {
            keys = NSDictionary(contentsOfFile: path)
            if let keysSafe = keys {
                return keysSafe["openAISecret"] as! String
            }
        }
        return ""
    }
    
}

// DEBUG

struct MOCK_DATA {
    let tokyoItinerarySevenDays = ""
}
