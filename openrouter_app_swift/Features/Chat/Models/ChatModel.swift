import Foundation

struct ChatMessage: Codable {
//    var id: UUID
    let content: String
    let role: String
    
    init(content: String, role: String) {
//        self.id = UUID()
        self.content = content
        self.role = role
    }
}

struct ChatRequest: Codable {
    let model: String
    let messages: [ChatMessage]
}

struct ChatResponse: Codable {
    struct Choice: Codable {
        let message: ChatMessage
    }
    let choices: [Choice]
}
