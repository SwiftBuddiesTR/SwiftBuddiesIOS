import Foundation
import Network
import BuddiesNetwork

struct ContributorActivitiesRequest: Requestable {
    @EncoderIgnorable var username: String?
    var page: Int = 1
    var per_page: Int = 30
    
    typealias Data = [ContributorContribution]
    
    enum CodingKeys: String, CodingKey {
        case page
        case per_page
    }
    
    func toUrlRequest() throws -> URLRequest {
        try URLProvider.returnUrlRequest(
            method: .get,
            url: APIs.GitHub.userActivities(username: username).url(.github),
            data: self
        )
    }
} 
