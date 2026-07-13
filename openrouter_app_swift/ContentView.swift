import SwiftUI

struct ContentView: View {
    @AppStorage("isDarkMode") private var isDarkMode = false
    @StateObject private var appState = AppStateViewModel()
    
    var body: some View {
        TabView(selection: $appState.selectedTab) {
            ChatView()
                .tabItem {
                    Label("Chat", systemImage: "message")
                }
                .tag(0)
            HistoryView()
                .tabItem {
                    Label("History", systemImage: "clock.arrow.trianglehead.counterclockwise.rotate.90")
                }
                .tag(1)
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear.circle")
                }
                .tag(2)
        }
        .preferredColorScheme(isDarkMode ? .dark : .light)
        .environmentObject(appState)
    }
}

#Preview {
    ContentView()
}
