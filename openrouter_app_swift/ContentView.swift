//
//  ContentView.swift
//  openrouter_app_swift
//
//  Created by Bank Indonesia on 01/07/26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            List {
                Section("Project Structure") {
                    Text("Core")
                    Text("Features/Chat")
                }
                Section("Status") {
                    Text("Folders are ready. Implement MVVM files next.")
                }
            }
            .navigationTitle("OpenRouter Swift")
        }
    }
}

#Preview {
    ContentView()
}
