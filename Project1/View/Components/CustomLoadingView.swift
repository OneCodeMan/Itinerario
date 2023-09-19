//
//  CustomLoadingView.swift
//  Project1
//
//  Created by Dave Gumba on 2023-09-19.
//

import SwiftUI

struct CustomLoadingView: View {
    @State var text: String = ""
    var body: some View {
        ProgressView(text)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding()
        
    }
}

struct CustomLoadingView_Previews: PreviewProvider {
    static var previews: some View {
        CustomLoadingView(text: "Loading")
    }
}
