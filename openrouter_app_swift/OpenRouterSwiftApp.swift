import SwiftUI
import SwiftData

@main
struct OpenRouterSwiftApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: HistoryItem.self)
        
#if os(macOS)
        MenuBarExtra("OpenRouter Credits", systemImage: "sparkles") {
            CreditsStatusBar()
        }.menuBarExtraStyle(.window)
#endif
    }
}

