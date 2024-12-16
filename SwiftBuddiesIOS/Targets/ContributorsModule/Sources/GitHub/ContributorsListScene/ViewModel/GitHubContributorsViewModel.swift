import Foundation
import Network
import BuddiesNetwork

@MainActor
public class GitHubContributorsViewModel: ObservableObject {
    @Published private(set) var contributors: [Contributor] = []
    @Published private(set) var isLoading = false
    @Published private(set) var error: Error?
    
    private let client: BuddiesClient
    
    init(client: BuddiesClient) {
        self.client = client
    }
    
    func fetchContributors() async {
        defer {
            isLoading = false
        }
        isLoading = true
        error = nil
        let request = ContributorsRequest()
        do {
            let response = try await client.perform(request)
            contributors = response.map { contributor in
                Contributor(
                    id: String(contributor.id),
                    name: contributor.login,
                    avatarURL: URL(string: contributor.avatarURL),
                    githubURL: URL(string: contributor.htmlURL),
                    contributions: contributor.contributions
                )
            }
        } catch {
            self.error = error
        }
    }
}

// MARK: - ContributorsRequest
struct ContributorsRequest: Requestable {
    typealias Data = [GitHubContributorResponse]
    
    struct GitHubContributorResponse: Codable {
        let login: String
        let id: Int
        let avatarURL: String
        let htmlURL: String
        let contributions: Int
        
        enum CodingKeys: String, CodingKey {
            case login
            case id
            case avatarURL = "avatar_url"
            case htmlURL = "html_url"
            case contributions
        }
    }

    func toUrlRequest() throws -> URLRequest {
        try URLProvider.returnUrlRequest(
            method: .get,
            url: APIs.GitHub.contributors.url(.github),
            data: self
        )
    }
}
