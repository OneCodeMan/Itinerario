//
//  ItineraryListView.swift
//  Project1
//
//  Created by Dave Gumba on 2023-09-08.
//

import SwiftUI

struct ItineraryListView: View {
    @StateObject var itineraryViewModel = ItineraryViewModel()
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        Group {
            let userSignedIn = viewModel.userSession != nil
            if userSignedIn {
                ForEach(itineraryViewModel.itineraries) { itinerary in
                    Text("hey")
                }
                // if user has itineraries
                // display itineraries
                // else
                // display "create an itinerary!"
            } else {
                Text("yoU Needa sign in bud")
            }
        }
        .task {
            print(itineraryViewModel.itineraries)
        }
    }
}

struct ItineraryListView_Previews: PreviewProvider {
    static var previews: some View {
        ItineraryListView()
    }
}
