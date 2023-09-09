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
    @State var city = "Paris"
    @State var numberOfDays = 3

    var body: some View {
        ScrollView {
            VStack {
                
                // The UI to send request
                Group {
                    TextField("City", text: $city)
                    Button {
                        Task { try await chatViewModel.sendItineraryRequest(city: city, numberOfDays: numberOfDays) }
                    } label: {
                        Text("Generate!")
                    }
                }
                
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
            }
            .padding()
        }
    }
}

struct CreateItineraryView_Previews: PreviewProvider {
    static var previews: some View {
        CreateItineraryView()
    }
}
