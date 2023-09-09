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
                ForEach(chatViewModel.response) { point in
                    Text(point)
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
