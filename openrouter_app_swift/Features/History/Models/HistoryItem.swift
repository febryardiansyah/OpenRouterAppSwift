import SwiftUI
import SwiftData

@Model
class HistoryItem: Identifiable {
    var id: UUID
    var title: String
    var lastMessage: String
    var selectedModel: PersistedAIModel
    var createdAt: Date
    
    init(title: String, lastMessage: String, selectedModel: PersistedAIModel) {
        self.id = UUID()
        self.title = title
        self.lastMessage = lastMessage
        self.selectedModel = selectedModel
        self.createdAt = Date()
    }
}

@Model
class PersistedAIModel {
    var id: String
    var name: String
    var desc: String
    
    init(id: String, name: String, desc: String) {
        self.id = id
        self.name = name
        self.desc = desc
    }
}

extension PersistedAIModel {
    func toAIModel() -> AIModel {
        return AIModel(id: self.id, name: self.name, description: self.desc)
    }
}
