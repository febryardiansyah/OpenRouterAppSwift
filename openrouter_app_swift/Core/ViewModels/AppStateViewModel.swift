import Combine

@MainActor
final class AppStateViewModel: ObservableObject {
    @Published var selectedTab: Int = 0
    @Published var historyItem: HistoryItem? = nil
}
