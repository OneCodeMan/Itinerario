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
    @State var chosenInterests = [Interest]()
    
    @State private var saveItineraryAlertShowing = false
    @State private var generateAnotherItineraryAlertPresented = false
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                ZStack(alignment: .topTrailing) {
                    
                    // The top x button to close the form
                    if !chatViewModel.isLoading && !generatingItinerary {
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "xmark")
                                .foregroundColor(Color.red)
                                .font(.title)
                                .padding(20)
                        }
                        .padding(.bottom, 5)
                    }

                    if !generatingItinerary {
                        VStack(alignment: .center, spacing: 10) {
                            Spacer()
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
                                
                                // TODO: fix the UI when all interests are made
                                // Interests
                                ControlGroup {
                                    ForEach(createItineraryViewModel.interests) { element in
                                        Button {
                                            chosenInterests.append(element)
                                            print(chosenInterests)
                                        } label: {
                                            Text(element.description)
                                        }
                                    }
                                }
                                .padding()
                                
                                // Generate button
                                Button {
                                    generatingItinerary.toggle()
                                    Task { try await chatViewModel.sendItineraryRequest(city: city, numberOfDays: numberOfDays, interests: chosenInterests) }
                                } label: {
                                    Text("Generate!")
                                        .font(.headline)
                                }
                                .buttonStyle(CustomRoundButton())
                                .disabled(city.isEmpty)
                                
                                Spacer()
                                Spacer()
                                
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
                                        
                                        // FIXME: breaks the UI
                                        //                                    Text(chosenInterests.map { $0.icon }.joined())
                                        //                                        .font(.caption)
                                        
                                        Divider()
                                        
                                        ForEach(Array(chatViewModel.highlightedActivities.enumerated()), id: \.offset) { index, element in
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
                                    .padding()
                                    
                                    if !chatViewModel.activities.isEmpty {
                                        VStack {
                                            Button {
                                                saveItineraryAlertShowing.toggle()
                                            } label: {
                                                Text("Save itinerary")
                                                    .frame(maxWidth: .infinity)
                                            }
                                            .alert(
                                                "Save to your itineraries?",
                                                isPresented: $saveItineraryAlertShowing
                                            ) {
                                                Button {
                                                    Task { try await createItineraryViewModel.uploadItinerary(city: self.city, numberOfDays: self.numberOfDays, details: chatViewModel.response) }
                                                    dismiss()
                                                } label: {
                                                    Text("Yes")
                                                }
                                                
                                                Button("Cancel", role: .cancel) {
                                                    
                                                }
                                                .foregroundColor(.red)
                                            } // alert
                                            .buttonStyle(CustomRectangularButton())
                                            
                                            Button {
                                                generateAnotherItineraryAlertPresented.toggle()
                                            } label: {
                                                Text("Generate another itinerary")
                                                    .frame(maxWidth: .infinity)
                                            }
                                            .alert(
                                                "Generate another itinerary? This current itinerary will be deleted.",
                                                isPresented: $generateAnotherItineraryAlertPresented
                                            ) {
                                                Button {
                                                    generatingItinerary.toggle()
                                                } label: {
                                                    Text("Yes")
                                                }
                                                
                                                Button("Cancel", role: .cancel) {
                                                    
                                                }
                                                .foregroundColor(.red)
                                            } // alert
                                            .buttonStyle(CustomRectangularButton())
                                        } // vstack
                                        .padding()
                                    }
                                    
                                } // scrollview
                            }
                            .padding()
                        } else {
                            VStack {
                                Spacer()
                                CustomLoadingView(text: "Generating itinerary")
                                Spacer()
                            }
                        }
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
