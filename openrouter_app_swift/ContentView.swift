//
//  ContentView.swift
//  openrouter_app_swift
//
//  Created by Bank Indonesia on 01/07/26.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            ChatView()
                .tabItem {
                    Label("Chat", systemImage: "message")
                }
                .tag(0)
            ChatView()
                .tabItem {
                    Label("History", systemImage: "clock.arrow.trianglehead.counterclockwise.rotate.90")
                }
                .tag(1)
            ChatView()
                .tabItem {
                    Label("Setting", systemImage: "gear.circle")
                }
                .tag(2)
        }
    }
}

#Preview {
    ContentView()
}
