//
//  FeedViewModel.swift
//  SwiftBuddiesIOS
//
//  Created by Kate Kashko on 1.11.2024.
//

import Foundation
import BuddiesNetwork
import Network
import UIKit
import Core

@MainActor
class BuddiesFeedViewModel: ObservableObject {
    @Published private(set) var posts: [Post] = []
    @Published private(set) var state: FeedState = .idle
    @Published private(set) var postImages: [String: UIImage] = [:]  // Cache for images
    
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
                
                for try await response in apiClient.watch(request, cachePolicy: .returnCacheDataAndFetch) {
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
                // Fetch images for new post
                Task {
                    await fetchImagesForPost(post)
                }
            }
            return isUnique
        }
        
        if isRefresh {
            posts.insert(contentsOf: uniquePosts, at: 0)
        } else {
            posts.append(contentsOf: uniquePosts)
        }
    }
    
    private func fetchImagesForPost(_ post: Post) async {
        guard !post.post.images.isEmpty else { return }
        
        for imageId in post.post.images {
            if let uid = imageId, postImages[uid] == nil {  // Check cache first
                do {
                    let request = GetImageRequest(uid: uid)
                    let response = try await apiClient.perform(request)
                    
                    
                    if let base64String = response.base64 {
                        // Remove the data URL prefix if it exists
                        let cleanBase64String = base64String.replacingOccurrences(
                            of: "data:image/\\w+;base64,",
                            with: "",
                            options: .regularExpression
                        )
                        
                        if let image = cleanBase64String.imageFromBase64 {
                            postImages[uid] = image
                        }
                    }
                } catch {
                    print("Failed to load image: \(error)")
                }
            }
        }
    }
}

// MARK: - Request Types
extension BuddiesFeedViewModel {
    /// Feed Request
    /// - limit: Number of items to fetch
    /// - offset: Offset for pagination
    /// - since: Date string to fetch posts since
    /// - Data: FeedResponseModel
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
    /// Get Image Request
    /// - Request body:
    ///    - uid: Image UID
    ///
    /// - Response body:
    ///    - base64: Image data in base64 format
    struct GetImageRequest: Requestable {
        let uid: String
        
        struct Data: Decodable {
            let base64: String?
        }
        
        func httpProperties() -> HTTPOperation<GetImageRequest>.HTTPProperties {
            .init(
                url: APIs.Feed.getImage.url(),
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
    /// Loading content
    /// - Parameter LoadingType: Loading type
    /// - initial: Initial loading
    /// - nextPage: Loading next page
    /// - refresh: Refreshing content
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
