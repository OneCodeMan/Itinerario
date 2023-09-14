//
//  TopTabBarView.swift
//  Project1
//
//  Created by Dave Gumba on 2023-09-14.
//

import SwiftUI

struct TopTabBarView: View {
    @Binding var currentTab: Int
    @Namespace var namespace

    var tabBarOptions: [String] = ["Details", "Highlights"]
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 20) {
                ForEach(Array(zip(self.tabBarOptions.indices, self.tabBarOptions)), id: \.0) { index, name in
                    TopTabBarItem(currentTab: self.$currentTab, namespace: namespace.self, tabBarItemName: name, tab: index)
                }
            }
            .padding(.horizontal)
        }
        .frame(height: 80)
        .background(Color.white)
        .edgesIgnoringSafeArea(.all)
    }
}

struct TopTabBarItem: View {
    @Binding var currentTab: Int
    let namespace: Namespace.ID

    var tabBarItemName: String
    var tab: Int
    
    var body: some View {
        Button {
            self.currentTab = tab
        } label: {
            VStack {
                Text(tabBarItemName)
                if currentTab == tab {
                    Color.black
                        .frame(height: 2)
                        .matchedGeometryEffect(id: "underline", in: namespace, properties: .frame)
                } else {
                    Color.clear.frame(height: 2)
                }
            }
            .animation(.spring(), value: self.currentTab)
        }
        .buttonStyle(.plain)
    }
}
