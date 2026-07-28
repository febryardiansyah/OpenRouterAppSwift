import Foundation
import Combine

final class RemainingCreditsViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var data: RemainingCredit?
    @Published var errorMessage: String?
    
    private let settingsRepository: SettingsRepositoryProtocol
    
    init() {
        settingsRepository = SettingsRepository()
    }
    
    func fetchRemainingCredits() async {
        isLoading = true
        
        do {
            data = try await settingsRepository.fetchRemainingCredits()
        } catch let error as APIError {
            errorMessage = error.parse()
        } catch {
            print("RemainingCreditsViewModel Err: \(error)")
            errorMessage = "Failed to fetch \(error)"
        }
        
        isLoading = false
    }
}
