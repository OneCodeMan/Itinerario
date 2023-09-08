//
//  ChatViewModel.swift
//  Project1
//
//  Created by Dave Gumba on 2023-09-08.
//

import Foundation

@MainActor
class ChatViewModel: ObservableObject {
    @Published var response = ""
    
    func sendItineraryRequest(city: String, country: String = "", numberOfDays: Int) async throws {
        print("DEBUG -- ChatViewModel -> sendItineraryRequest called\n")
        print("City: \(city) // Country: \(country)\n\n")
        
        let message = buildItineraryMessage(city: city, numberOfDays: numberOfDays)
        
        print("\n\n Message: \n\n\(message)\n\n")
        
        self.response = try await ChatService.getChatData(message: message)
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
