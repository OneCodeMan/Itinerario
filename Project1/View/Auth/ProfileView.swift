//
//  ProfileView.swift
//  Project1
//
//  Created by Dave Gumba on 2023-09-01.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @StateObject var createItineraryViewModel = CreateItineraryViewModel()
    @StateObject var itineraryViewModel = ItineraryViewModel()
    var body: some View {
        ZStack {
            VStack {
                if let user = viewModel.currentUser {
                    List {
                        Section {
                            HStack {
                                Text(user.initials)
                                    .font(.title)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)
                                    .frame(width: 72, height: 72)
                                    .background(Color(.systemGray3))
                                .clipShape(Circle())
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(user.fullName)
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                        .padding(.top, 4)
                                    
                                    Text(user.email)
                                        .font(.footnote)
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                        
                        Section("General") {
                            HStack {
                                SettingsRowView(imageName: "gear", title: "Version", tintColor: Color(.systemGray))
                                
                                Spacer()
                                
                                Text("1.0.0")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            
                            
                        }
                        
                        Section("Account") {
                            Button {
                                Task { try await itineraryViewModel.fetchItineraries() }
                            } label: {
                                SettingsRowView(imageName: "arrow.right.circle", title: "Fetch itineraries", tintColor: .red)
                            }
                            
                            Button {
                                Task { try await createItineraryViewModel.uploadItinerary() }
                            } label: {
                                SettingsRowView(imageName: "arrow.left.circle", title: "Submit sample itinerary", tintColor: .red)
                            }
                            
                            Button {
                                viewModel.signOut()
                            } label: {
                                SettingsRowView(imageName: "arrow.left.circle.fill", title: "Sign Out", tintColor: .red)
                            }
                            
                            Button {
                                print("Delete account..")
                            } label: {
                                SettingsRowView(imageName: "xmark.circle.fill", title: "Delete Account", tintColor: .red)
                            }
                        }
            }
        }
        
            }
            
            if viewModel.isLoading {
                ProgressView()
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
