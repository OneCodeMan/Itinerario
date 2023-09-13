//
//  ItineraryRowView.swift
//  Project1
//
//  Created by Dave Gumba on 2023-09-08.
//

import SwiftUI

struct ItineraryRowView: View {
    let itinerary: ItineraryDisplay
    var body: some View {
        HStack(alignment: .center) {
            Image(systemName: "airplane")
            Text("\(String(itinerary.numberOfDays)) days in \(itinerary.city)")
        }
        .padding()
    }
}
