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
    @Published private(set) var posts: [Post] = []
    @Published private(set) var state: FeedState = .idle
    
    private let apiClient: BuddiesClient
    private var paginationInfo = PaginationInfo(limit: 4)
    private var seenPostIds = Set<String>()
    private var currentTask: Task<Void, Never>?
    
    init(client: BuddiesClient = .shared) {
        self.apiClient = client
    }
    
    // MARK: - Public Methods
    
    func loadInitialContent() async {
        await fetchPosts(loading: .initial)
    }
    
    func refresh() async {
        currentTask?.cancel()
        
        paginationInfo.reset()
        seenPostIds.removeAll()
        posts.removeAll()
        
        await fetchPosts(loading: .refresh)
    }
    
    func loadMoreIfNeeded() async {
        guard paginationInfo.checkLoadingMore() else { return }
        
        paginationInfo.nextOffset()
        await fetchPosts(loading: .nextPage)
    }
    
    // MARK: - Private Methods
    
    private func fetchPosts(loading: FeedState.LoadingType) async {
        // Cancel any existing task
        currentTask?.cancel()
        
        state = .loading(loading)
        
        let task = Task { [weak self] in
            guard let self = self else { return }
            
            do {
                let request = FeedRequest(
                    limit: paginationInfo.limit,
                    offset: paginationInfo.offset,
                    since: nil
                )
                
                for try await response in apiClient.watch(request, cachePolicy: .fetchIgnoringCacheCompletely) {
                    if Task.isCancelled { break }
                    
                    if let newPosts = response.feed {
                        processPosts(newPosts, isRefresh: loading != .nextPage)
                        paginationInfo.hasMore = newPosts.count >= paginationInfo.limit
                    } else {
                        paginationInfo.hasMore = false
                    }
                    
                }
                
                if !Task.isCancelled {
                    state = .loaded(hasMore: paginationInfo.hasMore)
                }
            } catch {
                if !Task.isCancelled {
                    state = .error(.network(error.localizedDescription))
                }
            }
            
            paginationInfo.fetching = false
        }
        
        currentTask = task
        await task.value
    }
    
    private func processPosts(_ newPosts: [Post], isRefresh: Bool) {
        let uniquePosts = newPosts.filter { post in
            let isUnique = !seenPostIds.contains(post.post.id)
            if isUnique {
                seenPostIds.insert(post.post.id)
            }
            return isUnique
        }
        
        if isRefresh {
            posts.insert(contentsOf: uniquePosts, at: 0)
        } else {
            posts.append(contentsOf: uniquePosts)
        }
    }
}

// MARK: - Request Types
extension BuddiesFeedViewModel {
    struct FeedRequest: Requestable {
        enum FeedRequestType {
            case refresh
            case pagination
        }
        
        @EncoderIgnorable var type: FeedRequestType?
        let limit: Int
        let offset: Int
        let since: String?
        
        typealias Data = FeedResponseModel
        
        func httpProperties() -> HTTPOperation<FeedRequest>.HTTPProperties {
            .init(
                url: APIs.Feed.getFeed.url(),
                httpMethod: .get,
                data: self
            )
        }
    }
}

// MARK: - Feed States
/// Feed state
/// - idle: No content
/// - loading: Loading content
/// - error: Error state
/// - loaded: Content loaded
enum FeedState: Equatable {
    case idle
    case loading(LoadingType)
    case error(FeedError)
    case loaded(hasMore: Bool)
    
    /// Loading type
    /// - initial: Initial loading
    /// - nextPage: Loading next page
    /// - refresh: Refreshing content
    enum LoadingType: Equatable {
        case initial
        case nextPage
        case refresh
    }
    
    var isLoading: Bool {
        if case .loading = self { return true }
        return false
    }
    
    /// FeedError
    /// - network(String): Network error
    ///     - Parameter message: Error message
    /// - parsing: Parsing error
    /// - unknown: Unknown error
    enum FeedError: LocalizedError, Equatable {
        case network(String)
        case parsing
        case unknown
        
        var errorDescription: String? {
            switch self {
            case .network(let message):
                return "Network Error: \(message)"
            case .parsing:
                return "Failed to parse feed data"
            case .unknown:
                return "An unknown error occurred"
            }
        }
    }
}
