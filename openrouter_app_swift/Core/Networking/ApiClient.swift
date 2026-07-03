import Foundation

enum APIError: Error {
    case invalidUrl
    case serverError
    case decodingError
}

class ApiClient {
    static let shared = ApiClient()
    
    private let baseURL = "https://openrouter.ai/api/v1"
    
    private init() {}
    
    func request<T: Decodable> (endpoint: String, queryParams: [String: String]? = nil) async throws -> T {
        guard var urlComponents = URLComponents(string: "\(baseURL)/\(endpoint)") else {
            throw APIError.invalidUrl
        }
        
        if let queryParams = queryParams {
            urlComponents.queryItems = queryParams.map { URLQueryItem(name: $0.key, value: $0.value) }
        }
        
        guard let url = urlComponents.url else {
            throw APIError.invalidUrl
        }
                
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Bearer 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", forHTTPHeaderField: "Authorization")
        
        let(data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw APIError.serverError
        }
        
        do {
            let decodedData = try JSONDecoder().decode(T.self, from: data)
            
            return decodedData
        } catch {
            print("API REQUEST ERROR \(error)")
            throw APIError.decodingError
        }
    }
}
