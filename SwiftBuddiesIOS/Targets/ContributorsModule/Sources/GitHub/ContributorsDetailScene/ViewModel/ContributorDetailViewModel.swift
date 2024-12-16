//
//  File.swift
//  SwiftBuddiesMain
//
//  Created by dogukaan on 16.12.2024.
//  Copyright © 2024 SwiftBuddies. All rights reserved.
//

import Foundation
import Network
import BuddiesNetwork

@MainActor
class ContributorDetailViewModel: ObservableObject {
    @Published private(set) var contributorStats: ContributorStats?
    @Published private(set) var recentContributions: [ContributorContribution]?
    @Published private(set) var isStatsLoading = false
    @Published private(set) var isActivitiesLoading = false
    @Published private(set) var error: Error?
    @Published var availableRepoFilters: [RepoFilter] = []
    
    private var allContributions: [ContributorContribution] = []
    private var paginationInfo = PaginationInfo()
    
    var canLoadMore: Bool {
        paginationInfo.canLoadMore
    }
    
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
        defer {
            isStatsLoading = false
            isActivitiesLoading = false
            paginationInfo.isFetching = false
        }
        
        isStatsLoading = true
        isActivitiesLoading = true

        await fetchStats()
        await fetchActivities()
    }
    
    private func fetchStats() async {
        let request = ContributorStatsRequest(username: contributor.name)
        
        do {
            let data = try await client.perform(request)
            self.contributorStats = data
        } catch {
            self.error = error
        }
    }
    
    func fetchActivities() async {
        guard canLoadMore else { return }
        
        paginationInfo.nextPage()
        isActivitiesLoading = true
        paginationInfo.isFetching = true

        defer { 
            isActivitiesLoading = false
        }
        
        do {
            var request = ContributorActivitiesRequest(username: contributor.name)
            request.page = paginationInfo.currentPage
            request.per_page = paginationInfo.itemsPerPage
            
            let newContributions = try await client.perform(request)
            
            if newContributions.isEmpty {
                paginationInfo.totalCount = allContributions.count
            } else {
                if paginationInfo.currentPage == 1 {
                    allContributions = newContributions
                } else {
                    allContributions.append(contentsOf: newContributions)
                }
                paginationInfo.totalCount = allContributions.count
                updateFilters(with: allContributions)
                updateFilteredContributions()
            }
        } catch {
            self.error = error
        }
    }
    
    func refresh() async {
        paginationInfo.reset()
        allContributions.removeAll()
        await fetchContributorDetails()
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
    
    private func updateFilters(with contributions: [ContributorContribution]) {
        let uniqueRepos = Set(contributions.map { $0.repo.name })
        let newFilters = uniqueRepos.map { name in
            if let existing = availableRepoFilters.first(where: { $0.name == name }) {
                return existing
            }
            return RepoFilter(name: name)
        }
        availableRepoFilters = newFilters.sorted(by: { $0.name < $1.name })
    }
}
