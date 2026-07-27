import Foundation
import SwiftData

struct ChatMessage: Codable, Identifiable {
    var id: UUID = UUID()
    let content: String
    let role: String
    
    enum CodingKeys: String, CodingKey {
        case content, role
    }
}

struct ChatRequest: Codable {
    let model: String
    let messages: [ChatMessage]
}

struct ChatChoiceResponse: Codable {
    let message: ChatMessage
}

struct ChatResponse: Codable {
    let choices: [ChatChoiceResponse]
}

@Model
class PersistedChatMessage: Identifiable {
    var id: UUID
    var content: String
    var role: String
    var historyItem: HistoryItem?
    var createdAt: Date
    
    init(content: String, role: String, historyItem: HistoryItem? = nil) {
        self.id = UUID()
        self.content = content
        self.role = role
        self.historyItem = historyItem
        self.createdAt = Date()
    }
}

extension PersistedChatMessage {
    func toDTO() -> ChatMessage {
        ChatMessage(id: id, content: content, role: role)
    }
}
