//
//  CreateItineraryViewModel.swift
//  Project1
//
//  Created by Dave Gumba on 2023-09-07.
//

import Firebase

class CreateItineraryViewModel: ObservableObject {
    
    var interests = [
        Interest(title: "Bars", description: "bars", icon: "🍺"),
        Interest(title: "Cafes", description: "cafes", icon: "☕️"),
        Interest(title: "Museums", description: "museums", icon: "🏛️"),
        Interest(title: "Food", description: "food", icon: "🍴"),
        Interest(title: "Culture", description: "culture", icon: "🎭"),
        Interest(title: "Night Life", description: "night life", icon: "🌙"),
        Interest(title: "Nature", description: "nature", icon: "⛰️"),
        Interest(title: "History", description: "history", icon: "🗿"),
        Interest(title: "Scenic", description: "scenic spots", icon: "🏞️"),
        Interest(title: "Shopping", description: "shopping", icon: "🛍️"),
    ].sorted { $0.title < $1.title } // alphabetical order
    
    @Published var chosenInterests = [Interest]()
    
    func uploadItinerary(city: String, numberOfDays: Int, details: [String]) async throws {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let itinerary = Itinerary(ownerUid: uid, city: city, numberOfDays: numberOfDays, details: details, timestamp: Timestamp())
        try await ItineraryService.uploadItinerary(itinerary)
    }
}

extension CreateItineraryViewModel {
    
    func uploadMockItinerary() async throws {
        if let itinerary = mockItinerary3() {
            try await ItineraryService.uploadItinerary(itinerary)
        }
    }
    
    func mockItinerary1() -> Itinerary? {
        guard let uid = Auth.auth().currentUser?.uid else { return nil }
        return Itinerary(ownerUid: uid, country: "Italy", city: "Florence", numberOfDays: 4, details: ["Day 1 you do this", "Day 2 you do that", "Day 3 you do this & that", "Day 4 is a rest day", "Day 5 is a good time."], timestamp: Timestamp())
    }

    func mockItinerary2() -> Itinerary? {
        guard let uid = Auth.auth().currentUser?.uid else { return nil }
        return Itinerary(ownerUid: uid, country: "Germany", city: "Trier", numberOfDays: 3, details: ["Day 1 you do this", "Day 2 you do that", "Day 3 you do this & that"], timestamp: Timestamp())
    }
    
    func mockItinerary3() -> Itinerary? {
        guard let uid = Auth.auth().currentUser?.uid else { return nil }
        return Itinerary(ownerUid: uid, country: "France", city: "Paris", numberOfDays: 4, details: ["Day 1 you do this", "Day 2 you do that", "Day 3 you do this & that", "Day 4 you do nothing"], timestamp: Timestamp())
    }
}
