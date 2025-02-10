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
    
    func httpProperties() -> HTTPOperation<ContributorActivitiesRequest>.HTTPProperties {
        .init(
            url: APIs.GitHub.userActivities(username: username).url(.github),
            httpMethod: .get,
            data: self
        )
    }
}
