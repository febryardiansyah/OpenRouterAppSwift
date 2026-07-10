protocol ChatRepositoryProtocol {
    func fetchModels(query: String) async throws -> [AIModel]
    func sendMessage(chatRequest: ChatRequest) async throws -> ChatResponse
    func clarifyMessageTitle(for message: String) async throws -> String
}

final class ChatRepository: ChatRepositoryProtocol {
    func fetchModels(query: String) async throws -> [AIModel] {
        let response: AIModelResponse = try await ApiClient.shared.request(endpoint: "models", queryParams: ["q": query])
        
        return response.data
    }
    
    func sendMessage(chatRequest: ChatRequest) async throws -> ChatResponse {
        let response: ChatResponse = try await ApiClient.shared.request(
            endpoint: "chat/completions",
            method: .post,
            body: chatRequest
        )
        
        return response
    }
    
    func clarifyMessageTitle(for message: String) async throws -> String {
        let systemPrompt = "Clarify this text and make it as a title for chat history, make it simple, clean and to the point: \n\n\(message)"
        
        let chatRequest = ChatRequest(
            model: "deepseek/deepseek-v4-flash",
            messages: [.init(content: systemPrompt, role: "user")]
        )
        
        let response: ChatResponse = try await ApiClient.shared.request(
            endpoint: "chat/completions",
            method: .post,
            body: chatRequest
        )
        
        return response.choices.first?.message.content ?? message
    }
}
