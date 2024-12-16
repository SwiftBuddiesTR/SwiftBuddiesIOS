import Foundation
import Network
import BuddiesNetwork

struct ContributorStatsRequest: Requestable {
    typealias Data = ContributorStats
    let username: String
    
    func toUrlRequest() throws -> URLRequest {
        try URLProvider.returnUrlRequest(
            method: .get,
            url: APIs.GitHub.userStats(username: username).url(.github),
            data: self
        )
    }
} 
