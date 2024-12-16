import Foundation
import Network
import BuddiesNetwork

struct ContributorActivitiesRequest: Requestable {
    @EncoderIgnorable var username: String?
    
    typealias Data = [ContributorContribution]
    
    func toUrlRequest() throws -> URLRequest {
        try URLProvider.returnUrlRequest(
            method: .get,
            url: APIs.GitHub.userActivities(username: username).url(.github),
            data: self
        )
    }
} 
