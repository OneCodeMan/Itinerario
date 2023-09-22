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
    
    private let pasteboard = UIPasteboard.general
    
    @State private var toast: Toast? = nil
    
    @State var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d, yyyy 'at' HH:mm"
        return dateFormatter
    }()
    
    var body: some View {
        VStack {
            VStack {
                Text("\(itinerary.numberOfDays) Days in \(itinerary.city)")
                    .font(.largeTitle)
                    .frame(alignment: .center)
                
                Text("Created \(dateFormatter.string(from: itinerary.timestamp.dateValue()))")
                    .italic()
                    .foregroundColor(.gray)
                    .padding(.top, 1)
                    .font(.callout)
            }
            
            ZStack(alignment: .top) {
                TabView(selection: self.$currentTab) {
                    
                    // Details
                    ScrollView {
                        Spacer()
                            .frame(height: 80)
                        
                        HStack {
                            Spacer()
                            Button {
                                pasteboard.string = createPasteboardDataForActivities()
                                toast = Toast(type: .success, title: "Copied to clipboard", message: "")
                            } label: {
                                Label("", systemImage: "doc.on.clipboard.fill")
                                    .tint(Color.black)
                            }
                        }
                        
                        ForEach(Array(itinerary.activitiesWithHighlightedPlaces.enumerated()), id: \.offset) { index, element in
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
                    .toastView(toast: $toast)
                    
                    // Highlights
                    ScrollView {
                        Spacer()
                            .frame(height: 80)
                        
                        HStack {
                            Spacer()
                            Button {
                                pasteboard.string = createPasteboardDataForHighlights()
                                toast = Toast(type: .success, title: "Copied to clipboard", message: "")
                            } label: {
                                Label("", systemImage: "doc.on.clipboard.fill")
                                    .tint(Color.black)
                            }
                        }
                        
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
                    .toastView(toast: $toast)
                    
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .edgesIgnoringSafeArea(.all)
                
                TopTabBarView(currentTab: self.$currentTab)
            }
        }
    }
    
    /**
     Looks like this:
     
     Day 1
     - Head to the Naples National Archaeological Museum to explore ancient artifacts and artwork.
     - Visit the Naples Cathedral to admire its stunning architecture and artwork.
     - Take a stroll along the Spaccanapoli street to experience the vibrant atmosphere of Naples' historic center.

     Day 2
     - Explore the Pompeii Archaeological Park to witness the ancient ruins of the city destroyed by the eruption of Mount Vesuvius.
     - Visit the Herculaneum to see the well-preserved ruins of this ancient Roman town.
     - Take a scenic drive along the Amalfi Coast to enjoy breathtaking views of the coastline and visit charming towns like Positano and Amalfi.

     Day 3
     - Take a day trip to the Isle of Capri to explore its stunning natural beauty, visit the famous Blue Grotto, and enjoy the island's upscale shops and restaurants.
     - Visit the Royal Palace of Naples to admire its opulent architecture and explore its beautiful gardens.
     - Indulge in Naples' famous pizza by trying out different pizzerias in the city, such as Pizzeria Da Michele and Sorbillo.

     Day 4
     - Take a guided tour of the Naples Underground to discover the city's hidden tunnels and learn about its fascinating history.
     - Explore the Naples Botanical Garden to relax in its beautiful green spaces and admire a wide variety of plants and flowers.
     - End your day with a visit to the Castel dell'Ovo to enjoy panoramic views of the city and the Bay of Naples.
     */
    private func createPasteboardDataForActivities() -> String {
        var pasteboardString = "\(itinerary.numberOfDays) Days in \(itinerary.city)\n"
        
        for (index, activitySet) in itinerary.activities.enumerated() {
            let activitiesAsBulletPoints = activitySet.map { "- \($0)" }
            
            let dailyActivities = "Day \(index + 1)\n\(activitiesAsBulletPoints.joined(separator: "\n"))\n\n"
            pasteboardString += dailyActivities
        }
        
        return pasteboardString
    }
    
    /**
        Looks like this:
     Day 1:
      -Naples National Archaeological Museum, Naples Cathedral, Spaccanapoli
     Day 2:
      -Pompeii Archaeological Park, Herculaneum, Amalfi Coast
     Day 3:
      -Isle of Capri, Royal Palace of Naples, Pizzeria Da Michele, Sorbillo
     Day 4:
      -Naples Underground, Naples Botanical Garden, Castel dell'Ovo
     
     */
    private func createPasteboardDataForHighlights() -> String {
        var pasteboardString = "\(itinerary.numberOfDays) Days in \(itinerary.city)\n"
        
        for (index, placesSet) in itinerary.places.enumerated() {
            let dailyPlaces = "Day \(index + 1):\n -\(placesSet.joined(separator: ", ")) \n"
            pasteboardString += dailyPlaces
        }
        
        return pasteboardString
    }
}
