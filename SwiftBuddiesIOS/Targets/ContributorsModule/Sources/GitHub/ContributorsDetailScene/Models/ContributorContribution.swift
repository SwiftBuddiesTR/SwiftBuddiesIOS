import Foundation

struct ContributorContribution: Identifiable, Codable {
    let id: String
    let title: String
    let description: String
    let date: Date
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case description = "desc"
        case date = "created_at"
    }
} 