import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

class ApiClient {
    static let shared = ApiClient()
    
    private let baseURL = "https://openrouter.ai/api/v1"
    
    private init() {}
    
    func request<T: Decodable> (
        endpoint: String,
        method: HTTPMethod = .get,
        queryParams: [String: String]? = nil,
        body: Encodable? = nil
    ) async throws -> T {
        guard var urlComponents = URLComponents(string: "\(baseURL)/\(endpoint)") else {
            throw APIError.invalidUrl
        }
        
        if let queryParams = queryParams {
            urlComponents.queryItems = queryParams.map { URLQueryItem(name: $0.key, value: $0.value) }
        }
        
        guard let url = urlComponents.url else {
            throw APIError.invalidUrl
        }
        
        guard let apiKey = OpenRouterKeyService.getApiKey() else {
            throw APIError.apiKeyNotFound
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
//        request.addValue("Bearer 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", forHTTPHeaderField: "Authorization")
        
        print("REQUEST \(method.rawValue) | ENDPOINT \(endpoint)")
        
        if let body = body {
            do {
                print("REQUEST BODY \(body)")
                let encoder = JSONEncoder()
                
                request.httpBody = try encoder.encode(body)
            } catch {
                throw APIError.encodingError
            }
        }
        
        let(data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.serverError(errorData: ErrorData(error: .init(code: -1, message: "Non-HTTP response")))
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            if let decodedError = try? JSONDecoder().decode(ErrorData.self, from: data) {
                print("API REQUEST ERROR \(httpResponse.statusCode) | DATA \(decodedError)")
                throw APIError.serverError(errorData: decodedError)
            }
            throw APIError.serverError(errorData: ErrorData(error: .init(code: httpResponse.statusCode, message: "Unknown error")))
        }
        
        do {
            let decodedData = try JSONDecoder().decode(T.self, from: data)
            print("RESPONSE \(decodedData)")
            
            return decodedData
        } catch {
            print("API REQUEST DECODE ERROR \(error)")
            throw APIError.decodingError
        }
    }
}
