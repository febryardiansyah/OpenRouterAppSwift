import Foundation
import Combine

@MainActor
final class AIModelViewModel: ObservableObject {
    @Published var isLoading: Bool = true
    @Published var modelList: [AIModel] = []
    @Published var errorMessage: String? = nil
    
    private let chatService: ChatRepositoryProtocol
    
    init() {
        self.chatService = ChatRepository()
    }
    
    func fetchModels(query: String) async {
        isLoading = true
        errorMessage = nil
        do {
            modelList = try await chatService.fetchModels(query: query)
        } catch {
            errorMessage = "Failed to fetch \(error)"
        }
        isLoading = false
    }
    
}
