//
//  CreateItineraryView.swift
//  Project1
//
//  Created by Dave Gumba on 2023-09-07.
//

import SwiftUI

struct CreateItineraryView: View {
    @StateObject var createItineraryViewModel = CreateItineraryViewModel()
    @ObservedObject var chatViewModel = ChatViewModel()

    @State var generatingItinerary = false
    @State var city = "Paris"
    @State var numberOfDays = 3
    
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationView {
            ScrollView {
                if !generatingItinerary {
                    VStack {
                        // The UI to send request
                        Group {
                            TextField("City", text: $city)
                            Button {
                                Task { try await chatViewModel.sendItineraryRequest(city: city, numberOfDays: numberOfDays) }
                                generatingItinerary.toggle()
                            } label: {
                                Text("Generate!")
                            }
                            
                        }
                    }
                    .padding()
                } else {
                    // Ideally this is its own view, GeneratedItineraryView
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
                                    dismiss()
                                } label: {
                                    Text("Save to my itineraries")
                                }
                            }
                        } // scrollview
                    } else {
                        ProgressView("Generating itinerary")
                    }
                }
               
            }
        }
    }
}

struct CreateItineraryView_Previews: PreviewProvider {
    static var previews: some View {
        CreateItineraryView()
    }
}
