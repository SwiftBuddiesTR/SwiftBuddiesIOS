import Foundation
import Network
import BuddiesNetwork

struct ContributorStatsRequest: Requestable {
    @EncoderIgnorable var username: String?
    typealias Data = ContributorStats
    func httpProperties() -> HTTPOperation<ContributorStatsRequest>.HTTPProperties {
        .init(
            url: APIs.GitHub.userStats(username: username).url(.github),
            httpMethod: .get,
            data: self
        )
    }
}
