import SwiftUI
import SwiftData

@Model
class HistoryItem: Identifiable {
    var id: UUID
    var title: String
    var lastMessage: String
    var modelId: String
    var createdAt: Date
    
    init(title: String, lastMessage: String, modelId: String) {
        self.id = UUID()
        self.title = title
        self.lastMessage = lastMessage
        self.modelId = modelId
        self.createdAt = Date()
    }
}
