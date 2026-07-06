protocol ChatServiceProtocol {
    func fetchModels(query: String) async throws -> [AIModel]
    func sendMessage(chatRequest: ChatRequest) async throws -> Void
}

final class ChatService: ChatServiceProtocol {
    func fetchModels(query: String) async throws -> [AIModel] {
        let response: AIModelResponse = try await ApiClient.shared.request(endpoint: "models", queryParams: ["q": query])
        
        return response.data
    }
    
    func sendMessage(chatRequest: ChatRequest) async throws {
        let response: ChatResponse = try await ApiClient.shared.request(
            endpoint: "chat/completions",
            method: .post,
            body: chatRequest
        )
    }
}
