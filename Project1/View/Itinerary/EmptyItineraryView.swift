//
//  EmptyItineraryView.swift
//  Project1
//
//  Created by Dave Gumba on 2023-09-08.
//

import SwiftUI

struct EmptyItineraryView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    var body: some View {
        // if user is signed in
        if authViewModel.userSession != nil {
            Text("Create an itinerary!")
        } else {
            Button {
                RegistrationView()
            } label: {
                Text("Sign in or create an account to generate an itinerary!")
            }
        }
    }
}

struct EmptyItineraryView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyItineraryView()
    }
}
