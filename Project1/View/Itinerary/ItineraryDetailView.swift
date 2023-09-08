//
//  ItineraryDetailView.swift
//  Project1
//
//  Created by Dave Gumba on 2023-09-08.
//

import SwiftUI

struct ItineraryDetailView: View {
    let itinerary: Itinerary
    var body: some View {
        ScrollView {
            LazyVStack {
                Text("Detailview for \(itinerary.country), \(itinerary.city)")
                Text("hi")
                ForEach(itinerary.details) { detail in
                    Text(detail)
                }
                
            }
        }
    }
}
