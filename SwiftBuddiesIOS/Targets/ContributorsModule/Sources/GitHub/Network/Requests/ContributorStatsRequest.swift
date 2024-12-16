import Foundation
import Network
import BuddiesNetwork

struct ContributorStatsRequest: Requestable {
    @EncoderIgnorable var username: String?
    typealias Data = ContributorStats
    
    func toUrlRequest() throws -> URLRequest {
        try URLProvider.returnUrlRequest(
            method: .get,
            url: APIs.GitHub.userStats(username: username).url(.github),
            data: self
        )
    }
} 
