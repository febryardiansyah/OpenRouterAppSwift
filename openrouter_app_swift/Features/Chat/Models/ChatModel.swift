import Foundation

struct ChatMessage: Identifiable, Codable {
//    var id: UUID
    let content: String
    let role: String
    
    init(content: String, role: String) {
//        self.id = UUID()
        self.content = content
        self.role = role
    }
}

struct ChatRequestList: Encodable {
    let messages: [ChatMessage]
}

struct ChatResponseChoice: Decodable {
    let choices: [ChatMessage]
}
