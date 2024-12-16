import Foundation
import Network
import BuddiesNetwork

struct ContributorActivitiesRequest: Requestable {
    typealias Data = [ContributorContribution]
    let username: String
    
    func toUrlRequest() throws -> URLRequest {
        try URLProvider.returnUrlRequest(
            method: .get,
            url: APIs.GitHub.userActivities(username: username).url(.github),
            data: self
        )
    }
} 
