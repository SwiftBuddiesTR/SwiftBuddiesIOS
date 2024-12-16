import Foundation

struct ContributorContribution: Identifiable, Codable {
    let id: String
    let type: EventType
    let repo: Repository
    let createdAt: Date
    let payload: Payload
    
    struct Repository: Codable {
        let name: String
        let url: String
    }
    
    struct Payload: Codable {
        let action: String?
        let ref: String?
        let description: String?
    }
    
    enum EventType: String, Codable {
        case push = "PushEvent"
        case pullRequest = "PullRequestEvent"
        case pullRequestReview = "PullRequestReviewEvent"
        case issue = "IssueEvent"
        case create = "CreateEvent"
        case fork = "ForkEvent"
        case watch = "WatchEvent"
        case other
        
        init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            let rawValue = try container.decode(String.self)
            self = EventType(rawValue: rawValue) ?? .other
        }
    }
    
    var title: String {
        switch type {
        case .push: return "Pushed to \(repo.name)"
        case .pullRequest: return "Pull Request in \(repo.name)"
        case .pullRequestReview: return "Reviewed PR in \(repo.name)"
        case .issue: return "Issue in \(repo.name)"
        case .create: return "Created \(payload.ref ?? "") in \(repo.name)"
        case .fork: return "Forked \(repo.name)"
        case .watch: return "Starred \(repo.name)"
        case .other: return "Activity in \(repo.name)"
        }
    }
    
    var description: String {
        payload.description ?? "Contributed to \(repo.name)"
    }
    
    enum CodingKeys: String, CodingKey {
        case id, type, repo, payload
        case createdAt = "created_at"
    }
} 