//
//  CustomCheckbox.swift
//  Project1
//
//  Created by Dave Gumba on 2023-09-19.
//

import SwiftUI

struct CheckboxItem: View {
    let interest: Interest
    @State var isSelected = false
    
    var onSelected: () -> ()
    
    var body: some View {
        HStack {
            CustomCheckbox(isSelected: $isSelected)
            Text("\(interest.title) \(interest.icon)")
                .fontWeight(isSelected ? .bold : .regular)
        }
        .onTapGesture {
            isSelected.toggle()
            onSelected()
        }
    }
}

/// An indicator for showing when an item is selected
struct CustomCheckbox: View {

    /// The size for the indicator
    @ScaledMetric(relativeTo: .body) private var size: CGFloat = 20

    /// The line width for stroking the unselected indicator
    @ScaledMetric(relativeTo: .body) private var lineWidth: CGFloat = 1.5

    /// Flag that determines whether the indicator is shown as
    /// selected (true) or not (false)
    @Binding var isSelected: Bool

    var body: some View {
        if isSelected {

            // Show a round shape with a transparent tick
            Image(systemName: "checkmark.square.fill")
                .resizable()
                .scaledToFill()
                .foregroundColor(.blue)
                .frame(width: size + lineWidth, height: size + lineWidth)
        } else {

            // Just show an empty ring
//            Circle()
//                .stroke(lineWidth: lineWidth)
//                .foregroundColor(Color(UIColor.tertiaryLabel))
//                .frame(width: size, height: size)
//                .padding(lineWidth / 2)
            Rectangle()
                .stroke(lineWidth: lineWidth)
                .foregroundColor(Color(UIColor.tertiaryLabel))
                .frame(width: size, height: size)
                .padding(lineWidth / 2)
        }
    }
}
