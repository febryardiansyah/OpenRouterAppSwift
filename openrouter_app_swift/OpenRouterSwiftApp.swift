import SwiftUI
import SwiftData

@main
struct OpenRouterSwiftApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: HistoryItem.self)
    }
}
