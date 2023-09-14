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
                    VStack(alignment: .center, spacing: 10) {
                        Text("Create An Itinerary")
                            .font(.largeTitle)
                        // The UI to send request
                        Group {
                            TextField("City", text: $city)
                            Text("Duration: \(numberOfDays)")
                            Stepper("Duration (days)", value: $numberOfDays, in: 1...10)
                            Button {
                                Task { try await chatViewModel.sendItineraryRequest(city: city, numberOfDays: numberOfDays) }
                                generatingItinerary.toggle()
                            } label: {
                                Text("Generate!")
                            }
                            .buttonStyle(CustomButton())
                            
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
                                HStack {
                                    Button {
                                        Task { try await createItineraryViewModel.uploadItinerary(city: self.city, numberOfDays: self.numberOfDays, details: chatViewModel.response) }
                                        dismiss()
                                    } label: {
                                        Text("Save to my itineraries")
                                    }
                                    .buttonStyle(CustomButton())
                                    
                                    Button {
                                        generatingItinerary.toggle()
                                    } label: {
                                        Text("Generate another itinerary")
                                    }
                                    .buttonStyle(CustomButton())
                                }
                                .padding()
                            }
                        } // scrollview
                        .padding()
                    } else {
                        Spacer()
                        ProgressView("Generating itinerary")
                            .padding()
                        Spacer()
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
