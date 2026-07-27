import Foundation
import Combine

final class ClarifyMessageTitleViewModel: ObservableObject {
    @Published var title: String? = nil
    
    private let repository: ChatRepositoryProtocol
    
    init() {
        repository = ChatRepository()
    }
    
    func setTitle(for message: String) async {
        do {
            let title = try await repository.clarifyMessageTitle(for: message)
            
            self.title = title
        } catch {
            title = message.split(separator: " ").prefix(3).joined(separator: " ")
            print("Failed to clarify message to title: \(error)")
        }
    }
}
