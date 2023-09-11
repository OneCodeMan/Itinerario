//
//  GeneratedItineraryView.swift
//  Project1
//
//  Created by Dave Gumba on 2023-09-11.
//

import SwiftUI

struct GeneratedItineraryView: View {
    @StateObject var createItineraryViewModel = CreateItineraryViewModel()
    @ObservedObject var chatViewModel = ChatViewModel()
    let city: String
    let numberOfDays: Int

    var body: some View {
        NavigationView {
            
            if !chatViewModel.isLoading {
                ScrollView {
                    Text("\(numberOfDays) Days in \(city)")
                        .font(.title)
                    
                    // The response
                    ForEach(Array(chatViewModel.activities.enumerated()), id: \.element) { index, day in
                        Text("Day \(index + 1)")
                        ForEach(day, id: \.self) { activity in
                            Text(activity)
                        }
                    }
                    
                    if !chatViewModel.activities.isEmpty {
                        Button {
                            Task { try await createItineraryViewModel.uploadItinerary(city: self.city, numberOfDays: self.numberOfDays, details: chatViewModel.response) }
                        } label: {
                            Text("Save to my itineraries")
                        }
                    }
                } // scrollview
            } else {
                ProgressView("Generating itinerary")
            }
            
        } // nav view
        .task {
            Task { try await chatViewModel.sendItineraryRequest(city: city, numberOfDays: numberOfDays) }
        }
    }
}
