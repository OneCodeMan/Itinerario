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
    
    // ViewModel should have all these values
    @State var generatingItinerary = false
    @State var city = ""
    @State var numberOfDays = 2
    
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
                        // The UI to send request
                        Group {
                            VStack(alignment: .center, spacing: 12) {
                                Spacer()
                                Text("Create An Itinerary") // TODO: Localize
                                    .font(.largeTitle)
                                
                                
                                // Form stuff
                                
                                // City
                                GenerateItineraryInputView(text: $city, title: "City", placeholder: "Paris", fieldFontSize: 18.0)
                                
                                // Duration
                                VStack(alignment: .leading) {
                                    Text("Duration (days)") // TODO: LOcalize
                                        .foregroundColor(Color(.darkGray))
                                        .fontWeight(.semibold)
                                        .font(.system(size: 22.0))
                                    // FIXME: Hack
                                    Stepper(numberOfDays == 1 ? "\(numberOfDays) Day" :  "\(numberOfDays) Days", value: $numberOfDays, in: 1...10)
                                    
                                    Divider()
                                    
                                    // TODO: Localize
                                    Text("Interests")
                                        .foregroundColor(Color(.darkGray))
                                        .fontWeight(.semibold)
                                        .font(.system(size: 22.0))
                                    
                                    ScrollView {
                                        LazyVGrid(columns: [GridItem(.flexible(), spacing: 16), GridItem(.flexible(), spacing: 16)], alignment: .leading, spacing: 16) {
                                            ForEach(createItineraryViewModel.interests) { interest in
                                                CheckboxItem(interest: interest) {
                                                    // TODO: ViewModel functions???
                                                    let isCurrentInterestChosen = createItineraryViewModel.chosenInterests.contains(where: { $0.title == interest.title })
                                                    if isCurrentInterestChosen {
                                                        // Remove it from chosen interests on user tap
                                                        createItineraryViewModel.chosenInterests = createItineraryViewModel.chosenInterests.filter{ $0.title != interest.title }
                                                    } else {
                                                        // Add it to chosen interests on user tap.
                                                        createItineraryViewModel.chosenInterests.append(interest)
                                                    }
                                                }
                                            }
                                        }
                                        .padding(16)
                                    }
                                    
                                    Divider()
                                    
                                    // Generate button
                                    Button {
                                        generatingItinerary.toggle()
                                        Task { try await chatViewModel.sendItineraryRequest(city: city, numberOfDays: numberOfDays, interests: createItineraryViewModel.chosenInterests) }
                                    } label: {
                                        Text("Generate!") // TODO: Localize
                                            .font(.headline)
                                            .frame(maxWidth: .infinity)
                                    }
                                    .buttonStyle(CustomRectangularButton())
                                    .disabled(city.isEmpty)
                                    .padding()
                                    .frame(alignment: .center)
                                    
                                }

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
                                        .padding(.bottom, 4)
                                    }
                                    .padding(.bottom, 8)
                                    
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
                                        .padding(.top, 16)
                                    }
                                    
                                } // scrollview
                            }
                            .padding()
                        } else {
                            CustomLoadingView(text: "Generating itinerary")
                        }
                    }
                    
                }
            }
        } // scrollview
        
    }
}

struct CreateItineraryView_Previews: PreviewProvider {
    static var previews: some View {
        CreateItineraryView()
    }
}
