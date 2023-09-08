//
//  CreateItineraryView.swift
//  Project1
//
//  Created by Dave Gumba on 2023-09-07.
//

import SwiftUI

struct CreateItineraryView: View {
    @ObservedObject var chatViewModel = ChatViewModel()
    @State var city = "Paris"
    @State var numberOfDays = 3

    var body: some View {
        VStack {
            TextField("City", text: $city)
            Button {
                Task { try await chatViewModel.sendItineraryRequest(city: city, numberOfDays: numberOfDays) }
            } label: {
                Text("Generate!")
            }
        }
    }
}

struct CreateItineraryView_Previews: PreviewProvider {
    static var previews: some View {
        CreateItineraryView()
    }
}
