//
//  InputView.swift
//  Project1
//
//  Created by Dave Gumba on 2023-09-01.
//

import SwiftUI

struct AuthInputView: View {
    @Binding var text: String
    let title: String
    let placeholder: String
    var isSecureField = false
    
    var fieldFontSize = 14.0

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .foregroundColor(Color(.darkGray))
                .fontWeight(.semibold)
                .font(.footnote)
            
            if isSecureField {
                SecureField(placeholder, text: $text)
                    .font(.system(size: fieldFontSize))
            } else {
                TextField(placeholder, text: $text)
                    .font(.system(size: fieldFontSize))
            }
            
            Divider()
        }
    }
}

struct InputView_Previews: PreviewProvider {
    static var previews: some View {
        AuthInputView(text: .constant(""), title: "Email Address", placeholder: "name@example.com")
    }
}

// MARK: Generate Itinerary Input View
struct GenerateItineraryInputView: View {
    @Binding var text: String
    let title: String
    let placeholder: String
    var isSecureField = false
    
    var fieldFontSize = 14.0

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .foregroundColor(Color(.darkGray))
                .fontWeight(.semibold)
                .font(.system(size: 22.0))
            
            TextField(placeholder, text: $text)
                .font(.system(size: fieldFontSize))
            
            Divider()
        }
    }
}
