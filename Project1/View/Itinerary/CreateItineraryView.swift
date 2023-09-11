//
//  CreateItineraryView.swift
//  Project1
//
//  Created by Dave Gumba on 2023-09-07.
//

import SwiftUI

struct CreateItineraryView: View {
    @State var city = "Paris"
    @State var numberOfDays = 3

    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    
                    // The UI to send request
                    Group {
                        TextField("City", text: $city)
                        NavigationLink(destination: GeneratedItineraryView(city: city, numberOfDays: numberOfDays)) {
                            Text("Generate!")
                        }
                    }
                }
                .padding()
            }
        }
    }
}

struct CreateItineraryView_Previews: PreviewProvider {
    static var previews: some View {
        CreateItineraryView()
    }
}
