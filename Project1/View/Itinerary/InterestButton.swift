//
//  InterestButton.swift
//  Project1
//
//  Created by Dave Gumba on 2023-09-14.
//

// helpful: https://stackoverflow.com/a/62544642/5925014

import SwiftUI

struct Interest: Identifiable {
    let id = UUID()
    
    var title: String
    var description: String
    var isSelected: Bool = false
}

struct InterestButton: View {
    let interestTitle: String
    @State var isActivated = false
    var body: some View {
        Button {
            self.isActivated.toggle()
        } label: {
            Text(interestTitle)
                .padding()
        }
        .background(isActivated ? .blue : .white)
        .font(.system(size: 18))
        .padding()
        .buttonStyle(.borderedProminent)
    }
}

struct InterestButton_Previews: PreviewProvider {
    static var previews: some View {
        InterestButton(interestTitle: "Beer")
    }
}
