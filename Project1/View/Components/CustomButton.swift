//
//  CustomButton.swift
//  Project1
//
//  Created by Dave Gumba on 2023-09-13.
//

import SwiftUI

// MARK: Round button
struct CustomRoundButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
                    .padding()
                    .background(Color(red: 0, green: 0, blue: 0.5))
                    .foregroundStyle(.white)
                    .clipShape(Capsule())
    }
}

// MARK: Rectangular button, takes up whole horizontal, just put `.frame(maxWidth: .infinity)` on the Text()
struct CustomRectangularButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
                    .padding()
                    .background(Color(red: 0, green: 0, blue: 0.5))
                    .foregroundStyle(.white)
                    .clipShape(Rectangle())
    }
}
