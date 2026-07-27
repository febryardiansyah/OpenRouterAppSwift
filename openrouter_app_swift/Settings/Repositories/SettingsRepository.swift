protocol SettingsRepositoryProtocol {
    func fetchRemainingCredits() async throws -> RemainingCredit
}

struct SettingsRepository: SettingsRepositoryProtocol {
    func fetchRemainingCredits() async throws -> RemainingCredit {
        let response: RemainingCreditResponse = try await ApiClient.shared.request(endpoint: "credits")
        
        return response.data
    }
}
