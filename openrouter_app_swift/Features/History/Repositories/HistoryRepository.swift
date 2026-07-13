import SwiftData

struct HistoryRepository {
    static let shared = HistoryRepository()
    
    init() {}
    
    func logAction(item: HistoryItem, in context: ModelContext) {
        context.insert(item)
    }
    
    func clearAllHistory(items: [HistoryItem], in context: ModelContext) {
        for item in items {
            context.delete(item)
        }
    }
    
    func deleteItem(item: HistoryItem, in context: ModelContext) {
        context.delete(item)
    }
    
    func updateItem(item: HistoryItem, lastMessage: String? = nil, selectedModel: PersistedAIModel? = nil, in context: ModelContext) throws {
        if let lastMessage {
            item.lastMessage = lastMessage
        }
        
        if let selectedModel {
            item.selectedModel = selectedModel
        }
        
        try context.save()
    }
}
