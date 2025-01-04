//
//  FeedViewModel.swift
//  SwiftBuddiesIOS
//
//  Created by Kate Kashko on 1.11.2024.
//

import Foundation
import BuddiesNetwork
import Network

@MainActor
class BuddiesFeedViewModel: ObservableObject {
    @Published var posts: [Post] = []
    @Published var isLoading = false
    
    private let apiClient: BuddiesClient
    private var paginationInfo = PaginationInfo(itemsPerPage: 10) // Smaller page size for feed
    
    init() {
        self.apiClient = .shared
    }
    
    func fetchFeed(isRefreshing: Bool = false) async {
        if isRefreshing {
            paginationInfo.reset()
            posts = []
        }
        
        guard paginationInfo.canLoadMore else { return }
        
        paginationInfo.nextPage()
        isLoading = true
        
        let startIndex = (paginationInfo.currentPage - 1) * paginationInfo.itemsPerPage
        let endIndex = startIndex + paginationInfo.itemsPerPage
        let range = "\(startIndex)-\(endIndex)"
        
        var request = FeedRequest(range: range)
        
        do {
            let response = try await apiClient.perform(request)
            
            if let newPosts = response.feed {
                if paginationInfo.currentPage == 1 {
                    posts = newPosts
                } else {
                    posts.append(contentsOf: newPosts)
                }
                
                // Update total count based on the response
                paginationInfo.totalCount = (posts.count) + (newPosts.isEmpty ? 0 : paginationInfo.itemsPerPage)
            }
        } catch {
            print("Failed to fetch feed: \(error)")
            paginationInfo.currentPage -= 1 // Revert page increment on error
        }
        
        paginationInfo.isFetching = false
        isLoading = false
    }
}

// MARK: - FeedRequest
struct FeedRequest: Requestable {
    var range: String
    
    typealias Data = FeedResponseModel
    
    func httpProperties() -> BuddiesNetwork.HTTPOperation<FeedRequest>.HTTPProperties {
        .init(
            url: APIs.Feed.getFeed.url(),
            httpMethod: .get,
            data: self
        )
    }
}
