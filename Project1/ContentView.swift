//
//  ContentView.swift
//  Project1
//
//  Created by Dave Gumba on 2023-08-30.
//

import SwiftUI

struct ContentView: View {
    var chatService = ChatService()
    
    var body: some View {
        VStack {
            ProgressView()
                .task {
                    do {
                        let response = try await chatService.getChatData()
                        print(response)
                    } catch {
                        print("hi")
                    }
                }
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
