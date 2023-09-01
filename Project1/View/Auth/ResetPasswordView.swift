//
//  ResetPasswordView.swift
//  Project1
//
//  Created by Dave Gumba on 2023-09-01.
//

import SwiftUI

struct ResetPasswordView: View {
    @State private var email = ""
    @EnvironmentObject var viewModel: AuthViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            Image("firebase-logo")
                .resizable()
                .scaledToFill()
                .frame(width: 100, height: 140)
                .padding(.vertical, 32)
            
            InputView(text: $email, title: "Email Address", placeholder: "Enter email address associated with account")
                .padding()
            
            Button {
                viewModel.sendResetPasswordLink(toEmail: email)
                dismiss()
            } label: {
                HStack {
                    Text("SEND RESET LINK")
                        .fontWeight(.semibold)
                    Image(systemName: "arrow.right")
                }
                .foregroundColor(.white)
                .frame(width: UIScreen.main.bounds.width - 32, height: 50)
            }
            .background(Color(.systemBlue))
            .cornerRadius(10)
            .padding()
            
            Spacer()
            
            Button {
                dismiss()
            } label: {
                HStack {
                    Image(systemName: "arrow.left")
                    
                    Text("Back to Login")
                        .fontWeight(.semibold)
                }
            }
            
        }
    }
}

struct ResetPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ResetPasswordView()
    }
}
