import SwiftUI

struct AIModel: Identifiable, Codable {
    let id: String
    let name: String
    let description: String
    
    init(id: String, name: String, description: String) {
        self.id = id
        self.name = name
        self.description = description
    }
}

struct AIModelResponse: Codable {
    let data: [AIModel]
}
