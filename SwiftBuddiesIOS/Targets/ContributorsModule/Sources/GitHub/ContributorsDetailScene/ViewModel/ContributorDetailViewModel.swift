import Foundation
import Network
import BuddiesNetwork

@MainActor
class ContributorDetailViewModel: ObservableObject {
    @Published private(set) var contributorStats: ContributorStats?
    @Published private(set) var recentContributions: [ContributorContribution]?
    @Published private(set) var isLoading = false
    @Published private(set) var error: Error?
    @Published var availableRepoFilters: [RepoFilter] = []
    
    private var allContributions: [ContributorContribution] = []
    private let contributor: Contributor
    private let client: BuddiesClient
    
    init(contributor: Contributor) {
        self.contributor = contributor
        let interceptorProvider = GitHubInterceptorProvider(
            client: URLSessionClient(sessionConfiguration: .default)
        )
        
        self.client = BuddiesClient(
            networkTransporter: BuddiesRequestChainNetworkTransport.getChainNetworkTransport(
                interceptorProvider: interceptorProvider
            )
        )
    }
    
    func fetchContributorDetails() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            async let statsTask = fetchStats()
            async let contributionsTask = fetchRecentContributions()
            
            let (stats, contributions) = try await (statsTask, contributionsTask)
            self.contributorStats = stats
            self.allContributions = contributions
            
            // Create repo filters from unique repositories
            let uniqueRepos = Set(contributions.map { $0.repo.name })
            self.availableRepoFilters = uniqueRepos.map { RepoFilter(name: $0) }
            
            updateFilteredContributions()
        } catch {
            self.error = error
        }
    }
    
    func toggleRepoFilter(_ filter: RepoFilter) {
        if let index = availableRepoFilters.firstIndex(where: { $0.id == filter.id }) {
            availableRepoFilters[index].isSelected.toggle()
            updateFilteredContributions()
        }
    }
    
    func clearFilters() {
        availableRepoFilters = availableRepoFilters.map { RepoFilter(name: $0.name, isSelected: false) }
        updateFilteredContributions()
    }
    
    private func updateFilteredContributions() {
        let selectedRepos = Set(availableRepoFilters.filter(\.isSelected).map(\.name))
        
        if selectedRepos.isEmpty {
            recentContributions = allContributions
        } else {
            recentContributions = allContributions.filter { selectedRepos.contains($0.repo.name) }
        }
    }
    
    private func fetchStats() async throws -> ContributorStats {
        let request = ContributorStatsRequest(username: contributor.name)
        
        do {
            let data = try await client.perform(request)
            return data
        } catch {
            throw error
        }
    }
    
    private func fetchRecentContributions() async throws -> [ContributorContribution] {
        let request = ContributorActivitiesRequest(username: contributor.name)
        do {
            let data = try await client.perform(request)
            return data
        } catch {
            throw error
        }
    }
}
