import Foundation

struct OpenRouterKeyService {
    static func setApiKey(value: String) {
        UserDefaults.standard.set(value, forKey: "ApiKey")
    }
    
    static func getApiKey() -> String? {
        let key = UserDefaults.standard.string(forKey: "ApiKey")
        
        return key
    }
}
