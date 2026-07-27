import KeychainAccess
import Foundation

class KeyChainManager {
    static let shared = KeyChainManager()
    init() {}
    
    private let keyChain = Keychain(service: "com.febryards.openrouterapp", accessGroup: "U496PJH398.com.febryards.openrouterapp.shared")
    private let apiKeyConstant = "user_api_key"
    
    func saveApiKey(_ value: String) {
        let cleanValue = value.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !cleanValue.isEmpty else {
            return
        }
        
        keyChain[apiKeyConstant] = value
    }
    
    func getApiKey() -> String? {
        return keyChain[apiKeyConstant]
    }
    
    func removeApiKey() {
        do {
            try keyChain.remove(apiKeyConstant)
        } catch {
            print("Failed to remove API Key: \(error.localizedDescription)")
        }
    }
}
