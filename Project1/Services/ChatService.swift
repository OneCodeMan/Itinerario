//
//  ChatService.swift
//  Project1
//
//  Created by Dave Gumba on 2023-08-31.
//

import Foundation
import ChatGPTSwift

struct ChatService {
    
    public var responseData: String = ""
    let API_KEY = "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"
    
    // Function to call ChatGPT here
    func getChatData(city: String, numberOfDays: Int) async throws -> String {
        do {
            let api = ChatGPTAPI(apiKey: API_KEY)
            
            let message = buildItineraryMessage(city: city, numberOfDays: numberOfDays)
            
            let response = try await api.sendMessage(text: message,
                                                     model: "gpt-3.5-turbo")
            print(response)
            return response
        } catch {
            print(error.localizedDescription)
        }
            
        return ""
    }
    
    private func buildItineraryMessage(city: String, country: String = "", numberOfDays: Int) -> String {
        let message = """
            Answer in plain text please. Recommend me a \(numberOfDays) day itinerary to \(city) \(country). Add the delimiter "!@#$%^&*" after each set of activities. Add "<place>" and "</place>" between each monument and mentioned place. Instead of bullet points, use the tags "<activity>" and "</activity>"

            Format:

            !@#$%^&*
            Day 1:
            <activity>Head to the <place>PLACE HERE</place> to check stuff out. </activity>
            !@#$%^&*
            Day 2:
            <activity>Head to the <place>PLACE HERE</place> </activity>
            !@#$%^&*
            Day 3:
            <activity>Head to the <place>PLACE HERE</place> </activity>
            !@#$%^&*
            """
        return message
    }
    
}

struct MOCK_DATA {
    
    let tokyoItinerarySevenDays = ""
    
}
