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
}
