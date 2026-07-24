import Combine

final class ModelDetailViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var data: AIModelDetail?
    @Published var errorMessage: String?
    
    private let repository: ModelDetailRepositoryProtocol
    
    init(_ repository: ModelDetailRepositoryProtocol = ModelDetailRepository()) {
        self.repository = repository
    }
    
    func fetchModelDetail(author: String, slug: String) async {
        isLoading = true
        errorMessage = nil
        
        do {
            data = try await repository.fetchModelDetail(author: author, slug: slug)
        } catch let error as APIError {
          errorMessage = error.parse()
        } catch {
            errorMessage = "Failed to fetch model detail."
        }
        
        isLoading = false
    }
}
