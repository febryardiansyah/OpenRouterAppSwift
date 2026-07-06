import Foundation

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
