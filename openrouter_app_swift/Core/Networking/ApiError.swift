enum APIError: Error {
    case invalidUrl
    case serverError(errorData: ErrorData)
    case decodingError
    case encodingError
    case apiKeyNotFound
}

struct ErrorData: Codable {
    struct Error: Codable {
        let code: Int
        let message: String
    }
    
    let error: Error
}

extension APIError {
    func parse() -> String{
        return HandleApiError(self)
    }
}

func HandleApiError(_ error: APIError) -> String {
    switch error {
    case .invalidUrl:
        return "Invalid Url"
    case .serverError(let errorData):
        if errorData.error.code == 401 {
            return "Api key is not valid or not provided"
        }
        return "\(errorData.error.message)"
    case .decodingError:
        return "Failed to decode data"
    case .encodingError:
        return "Failed to encode data"
    case .apiKeyNotFound:
        return "API key is required"
    }
}
