//
//  ItineraryDetailView.swift
//  Project1
//
//  Created by Dave Gumba on 2023-09-08.
//

import SwiftUI

struct ItineraryDetailView: View {
    let itinerary: ItineraryDisplay
    @State var currentTab: Int = 0
    var body: some View {
        VStack {
            Text("\(itinerary.numberOfDays) Days in \(itinerary.city)")
                .font(.largeTitle)
                .frame(alignment: .center)
            
            ZStack(alignment: .top) {
                TabView(selection: self.$currentTab) {
                    
                    // Details
                    ScrollView {
                        Spacer()
                            .frame(height: 80)
                        ForEach(Array(itinerary.activities.enumerated()), id: \.offset) { index, element in
                            Text("Day \(index + 1)")
                                .font(.title)
                            
                            ForEach(element, id: \.self) { activity in
                                VStack {
                                    Text("\u{2022} \(activity)")
                                        .padding(5)
                                }
                                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading) // Achieves the Text() alignment we want
                            }
                            
                            Divider()
                        }
                        .padding(5)
                    }
                    .tag(0)
                    
                    // Highlights
                    ScrollView {
                        Spacer()
                            .frame(height: 80)
                        
                        ForEach(Array(itinerary.places.enumerated()), id: \.offset) { index, element in
                            HStack {
                                
                                Text("Day \(index + 1)")
                                    .bold()
                                
                                Divider()
                                    .frame(width: 0.5)
                                    .overlay(Color.black)
                                
                                VStack(alignment: .leading) {
                                    ForEach(element, id: \.self) { place in
                                        Text("\u{2022} \(place)")
                                            .font(.system(size: 13))
                                    }
                                }
                            }
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 5)
                            
                            Divider()
                        }
                        .padding(3)
                    }
                    .tag(1)
                    
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .edgesIgnoringSafeArea(.all)
                
                TopTabBarView(currentTab: self.$currentTab)
            }
        }
    }
}
