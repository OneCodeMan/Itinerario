//
//  AuthViewModel.swift
//  Project1
//
//  Created by Dave Gumba on 2023-09-01.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestoreSwift

protocol AuthenticationFormProtocol {
    var formIsValid: Bool { get }
}

@MainActor
class AuthViewModel: ObservableObject {
    
    // Tells us whether or not we have a user logged in
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    @Published var authError: AuthError?
    @Published var showAlert = false
    @Published var isLoading = false
    
    init() {
        self.userSession = Auth.auth().currentUser
        
        print("authviewmodel init -- self.userSession assigned")
        
        Task {
            print("authviewmodel init -- fetchUser")
            isLoading = true
            await fetchUser()
            isLoading = false
        }
    }
    
    func signIn(withEmail email: String, password: String) async throws {
        isLoading = true

        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
            await fetchUser()
            isLoading = false
        } catch {
            let authError = AuthErrorCode.Code(rawValue: (error as NSError).code)
            self.showAlert = true
            self.authError = AuthError(authErrorCode: authError ?? .userNotFound)
            isLoading = false
        }
    }
    
    func createUser(withEmail email: String, password: String, fullName: String) async throws {
        isLoading = true
        
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user
            let user = User(id: result.user.uid, fullName: fullName, email: email)
            let encodedUser = try Firestore.Encoder().encode(user)
            
            // This is how we get the data into Firebase
            try await Firestore.firestore().collection("users").document(user.id).setData(encodedUser)
            
            // After we upload the user to Firebase, we fetch the data we just uploaded then we
            // set that as our current user.
            await fetchUser()
            
            isLoading = false
        } catch {
            let authError = AuthErrorCode.Code(rawValue: (error as NSError).code)
            self.showAlert = true
            self.authError = AuthError(authErrorCode: authError ?? .userNotFound)
            isLoading = false
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut() // signs out user on backend
            self.userSession = nil // wipes out user session, takes us back to login screen
            self.currentUser = nil
        } catch {
            print("DEBUG: Failed to sign out with error \(error.localizedDescription)")
        }
    }
    
    func deleteAccount() async throws {
        do {
            try await Auth.auth().currentUser?.delete()
            deleteUserData()
            self.currentUser = nil
            self.userSession = nil
        } catch {
            print("DEBUG: Failed to delete account with error \(error.localizedDescription)")
        }
    }
    
    func sendResetPasswordLink(toEmail email: String) {
        Auth.auth().sendPasswordReset(withEmail: email)
    }
    
    func fetchUser() async {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let snapshot = try? await Firestore.firestore().collection("users").document(uid).getDocument()
        guard let user = try? snapshot?.data(as: User.self) else { return }
        self.currentUser = user
     
        print("DEBUG: current user is \(self.currentUser)")
    }
    
    func deleteUserData() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Firestore.firestore().collection("users").document(uid).delete()
    }
}
