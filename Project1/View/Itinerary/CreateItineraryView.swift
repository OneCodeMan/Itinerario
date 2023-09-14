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
    @State var city = ""
    @State var numberOfDays = 3
    
    // FIXME: The viewmodel should have this
    @State var interests = [InterestButton(interestTitle: "Alcohol"),
                            InterestButton(interestTitle: "Coffee"),
                            InterestButton(interestTitle: "Night Life"),
                            InterestButton(interestTitle: "Nature"),
                            InterestButton(interestTitle: "Good Weather"),
                            InterestButton(interestTitle: "Culture"),
                            InterestButton(interestTitle: "Beaches"),
                            InterestButton(interestTitle: "Scenic spots"),
                            InterestButton(interestTitle: "History"),
                            InterestButton(interestTitle: "Good food")]
    
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
                            // Form stuff
                            
                            // City
                            GenerateItineraryInputView(text: $city, title: "City", placeholder: "Paris", fieldFontSize: 18.0)
                            
                            // Duration
                            HStack {
                                Text("Duration (days): \(numberOfDays)")
                                Stepper("Days", value: $numberOfDays, in: 1...10)
                            }
                            
                            // Interests
                            InterestButton(interestTitle: "Beer")
                           
                            // Generate button
                            Button {
                                generatingItinerary.toggle()
                                Task { try await chatViewModel.sendItineraryRequest(city: city, numberOfDays: numberOfDays) }
                            } label: {
                                Text("Generate!")
                            }
                            .buttonStyle(CustomButton())
                            
                        } // group
                    }
                    .padding()
                } else {
                    // Ideally this is its own view, GeneratedItineraryView
                    if !chatViewModel.isLoading {
                        // Duplicated from ItineraryDetailView
                        Group {
                            ScrollView {
                                LazyVStack {
                                    Text("\(numberOfDays) Days in \(city)")
                                        .font(.largeTitle)
                                    
                                    Divider()
                                    
                                    ForEach(Array(chatViewModel.activities.enumerated()), id: \.offset) { index, element in
                                        Text("Day \(index + 1)")
                                            .font(.title)

                                        ForEach(element, id: \.self) { activity in
                                            VStack {
                                                Text("\u{2022} \(activity)")
                                                    .padding(5)
                                            }
                                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading) // Achieves the Text() alignment we want
                                        }
                                        
                                        Divider()
                                    }
                                    .padding(10)
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
                        }
                        
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
