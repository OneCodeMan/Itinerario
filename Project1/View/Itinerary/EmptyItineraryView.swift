//
//  EmptyItineraryView.swift
//  Project1
//
//  Created by Dave Gumba on 2023-09-08.
//

import SwiftUI

struct EmptyItineraryView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var onRegistrationTap: () -> ()
    
    var body: some View {
        Button {
            onRegistrationTap()
        } label: {
            Text(authViewModel.userSession != nil ? "Create an itinerary!" : "Sign in or create an account to generate an itinerary!")
        }
    }
}

