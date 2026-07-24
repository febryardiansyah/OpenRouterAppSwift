protocol ModelDetailRepositoryProtocol {
    func fetchModelDetail(author: String, slug: String) async throws -> AIModelDetail
}

final class ModelDetailRepository: ModelDetailRepositoryProtocol {
    func fetchModelDetail(author: String, slug: String) async throws -> AIModelDetail {
        let response: AIModelDetailResponse = try await ApiClient.shared.request(endpoint: "model/\(author)/\(slug)")
        
        return response.data
    }
}
