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
        }
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
