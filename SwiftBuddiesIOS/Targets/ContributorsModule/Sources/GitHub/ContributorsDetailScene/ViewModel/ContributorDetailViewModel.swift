import Foundation
import Network
import BuddiesNetwork

@MainActor
class ContributorDetailViewModel: ObservableObject {
    @Published private(set) var contributorStats: ContributorStats?
    @Published private(set) var recentContributions: [ContributorContribution]?
    @Published private(set) var isLoading = false
    @Published private(set) var error: Error?
    
    private let contributor: Contributor
    private let client: BuddiesClient
    
    init(contributor: Contributor) {
        self.contributor = contributor
        let interceptorProvider = GitHubInterceptorProvider(client: URLSessionClient(sessionConfiguration: .default))
        self.client = BuddiesClient(
            networkTransporter: BuddiesRequestChainNetworkTransport.getChainNetworkTransport(
                interceptorProvider: interceptorProvider
            )
        )
    }
    
    func fetchContributorDetails() async {
        isLoading = true
        defer { isLoading = false }
        
        async let statsTask = fetchStats()
        async let contributionsTask = fetchRecentContributions()
        
        do {
            let (stats, contributions) = try await (statsTask, contributionsTask)
            self.contributorStats = stats
            self.recentContributions = contributions
        } catch {
            self.error = error
        }
    }
    
    private func fetchStats() async throws -> ContributorStats {
        let request = ContributorStatsRequest(username: contributor.name)
        return try await client.perform(request)
    }
    
    private func fetchRecentContributions() async throws -> [ContributorContribution] {
        let request = ContributorActivitiesRequest(username: contributor.name)
        return try await client.perform(request)
    }
}
