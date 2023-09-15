//
//  ChatViewModel.swift
//  Project1
//
//  Created by Dave Gumba on 2023-09-08.
//

/**
 Responsible for
 a) taking user input,
 b) generating a message to OpenAI with the user input
 c) handling the response from OpenAI, and
 d) sending the OpenAI response to the view
 */

import Foundation

@MainActor
class ChatViewModel: ObservableObject {
    @Published var response: [String] = []
    @Published var places: [[String]] = []
    @Published var activities: [[String]] = []
    @Published var highlightedActivities: [[AttributedString]] = []
    @Published var isLoading = false
    
    // TODO: add parameter "interests" here, then an array that stores the filter of for selected ones
    func sendItineraryRequest(city: String, country: String = "", numberOfDays: Int) async throws {
        print("DEBUG -- ChatViewModel -> sendItineraryRequest called\n")
        print("City: \(city) // Country: \(country)\n\n")
        
        let message = buildItineraryMessage(city: city, numberOfDays: numberOfDays)
        
        print("\n\n Message: \n\n\(message)\n\n")
        
        // Fetch from API, get response
        isLoading = true
        let rawResponse = try await ChatService.getChatData(message: message)
        
        // Parse the response.
        let parsedResponseData = await ItineraryParser.parseResponseFromOpenAI(rawResponse: rawResponse)
        self.response = parsedResponseData.parsedResponse
        self.places = parsedResponseData.places
        self.activities = parsedResponseData.activities
        self.highlightedActivities = parsedResponseData.highlightedActivities
        
        isLoading = false
        
        print("Here's the parsed response from ChatViewModel: \n\n")
        print(self.response)
        print("Here are the places:\n")
        print(self.places)
        print("\n\nHere are the activities:\n")
        print(self.activities)
        print("\n\nHere are the HIGHLIGHTED activities:\n")
        print(self.highlightedActivities)
    }

    private func buildItineraryMessage(city: String, country: String = "", numberOfDays: Int, interests: [Interest] = []) -> String {
        
        // TODO: remove this later, dummy data
        let interests = [Interest(title: "Bars", description: "bars", isSelected: true),
                         Interest(title: "Cafes", description: "cafes"),
                         Interest(title: "Museums", description: "museums", isSelected: true),
                         Interest(title: "Scenery", description: "scenic spots")]
        
        
        let message = """
            Answer in plain text please. Recommend me a \(numberOfDays) day itinerary to \(city) \(country).
            
            My interests are: \(buildInterests(interests: interests)).
            
            Add the delimiter "!@#$%^&*" after each set of activities. Add "<place>" and "</place>" between each monument and mentioned place. Instead of bullet points, use the tags "<activity>" and "</activity>"

            Format Example:

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
    
    private func buildInterests(interests: [Interest]) -> String {
        let interestsPortion = "\(interests.filter{ $0.isSelected }.map { "\($0.description)" }.reduce("") { $0 + ", " + $1 })"
        return interestsPortion
    }
}
