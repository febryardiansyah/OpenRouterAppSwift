import Foundation

struct RemainingCredit: Codable {
    let totalCredits: Double
    let totalUsage: Double
    
    enum CodingKeys: String, CodingKey {
        case totalCredits = "total_credits"
        case totalUsage = "total_usage"
    }
}

struct RemainingCreditResponse: Codable {
    let data: RemainingCredit
}

extension Double {
    var formattedCredit: String {
        self.formatted(.number.precision(.fractionLength(2)))
    }
}
