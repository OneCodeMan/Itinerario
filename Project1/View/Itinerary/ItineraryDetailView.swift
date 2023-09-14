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
                
                Divider()
                
                ForEach(Array(itinerary.activities.enumerated()), id: \.offset) { index, element in
                    Text("Day \(index + 1)")
                        .font(.title)
                        .padding(5)

                    ForEach(element, id: \.self) { activity in
                        VStack {
                            Text("\u{2022} \(activity)")
                        }
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading) // Achieves the Text() alignment we want
                    }
                    
                    Divider()
                }
                .padding(10)
            }
        }
    }
}
