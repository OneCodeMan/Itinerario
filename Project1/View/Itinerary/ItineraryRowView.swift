//
//  ItineraryRowView.swift
//  Project1
//
//  Created by Dave Gumba on 2023-09-08.
//

import SwiftUI

struct ItineraryRowView: View {
    let itinerary: Itinerary
    var body: some View {
        VStack {
            Text("\(String(itinerary.numberOfDays)) days in \(itinerary.city), \(itinerary.country)")
        }
        .background(Color.green)
    }
}
