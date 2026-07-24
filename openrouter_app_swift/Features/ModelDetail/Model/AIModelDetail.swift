import Foundation

struct AIModelDetail: Codable {
    let id: String
    let name: String
    let pricing: Pricing
    let description: String
    let architecture: Architecture
    let contextLength: Int
    let created: Date
    
    struct Pricing: Codable {
        let completion: String?
        let image: String?
        let prompt: String?
        let request: String?
    }
    
    struct Architecture: Codable {
        let tokenizer: String?
        let inputModalities: [String]?
        let modality: String?
        let instructType: String?
        
        enum CodingKeys: String, CodingKey {
            case tokenizer
            case inputModalities = "input_modalities"
            case modality
            case instructType = "instruct_type"
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case pricing
        case description
        case architecture
        case contextLength = "context_length"
        case created
    }

}

struct AIModelDetailResponse: Codable {
    let data: AIModelDetail
}
