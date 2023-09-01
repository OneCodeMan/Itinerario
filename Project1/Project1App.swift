//
//  Project1App.swift
//  Project1
//
//  Created by Dave Gumba on 2023-08-30.
//

import SwiftUI
import Firebase

@main
struct LoginSignUpApp: App {
    @StateObject var viewModel = AuthViewModel()
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
        }
    }
}
