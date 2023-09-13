//
//  ItineraryDetailView.swift
//  Project1
//
//  Created by Dave Gumba on 2023-09-08.
//

import SwiftUI

struct ItineraryDetailView: View {
    let itinerary: ItineraryDisplay
    var body: some View {
        ScrollView {
            LazyVStack {
                Text("\(itinerary.numberOfDays) Days in \(itinerary.city)")
                    .font(.largeTitle)
                
                ForEach(Array(itinerary.activities.enumerated()), id: \.offset) { index, element in
                    Text("Day \(index + 1)")
                        .font(.title)
                        .padding()

                    ForEach(element, id: \.self) { activity in
                        Text(activity)
                    }
                    
                    Divider()
                }
                .padding()
            }
        }
    }
}
