import Foundation
import Combine

final class SendMessageViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var data: ChatChoiceResponse?
    @Published var errorMessage: String?
    
    private let chatRepository: ChatRepositoryProtocol
    
    init() {
        self.chatRepository = ChatRepository()
    }
    
    func sendMessage(chatRequest: ChatRequest) async throws -> Void{
        isLoading = false
        errorMessage = nil
        
        do {
            let response: ChatResponse = try await chatRepository.sendMessage(chatRequest: chatRequest)
            
            self.data = response.choices.first
        } catch {
            errorMessage = "Failed to send message \(error)"
        }
        
        isLoading = false
    }
}
