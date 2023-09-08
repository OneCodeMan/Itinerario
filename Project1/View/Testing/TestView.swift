//
//  TestView.swift
//  Project1
//
//  Created by Dave Gumba on 2023-09-08.
//

import SwiftUI

struct TestView: View {
    @StateObject var createItineraryViewModel = CreateItineraryViewModel()
    @StateObject var itineraryViewModel = ItineraryViewModel()
    @StateObject var chatViewModel = ChatViewModel()
    
    var body: some View {
        VStack {
            Button {
                Task { try await itineraryViewModel.fetchItineraries() }
            } label: {
                SettingsRowView(imageName: "arrow.right.circle", title: "Fetch itineraries", tintColor: .red)
            }
            
            Button {
                Task { try await createItineraryViewModel.uploadMockItinerary() }
            } label: {
                SettingsRowView(imageName: "arrow.left.circle", title: "Submit sample itinerary", tintColor: .red)
            }
            
            Button {
                Task { try await chatViewModel.sendItineraryRequest(city: "Lisbon", numberOfDays: 2) }
            } label: {
                SettingsRowView(imageName: "bolt.fill", title: "Send sample OpenAI request", tintColor: .red)
            }
        }
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
