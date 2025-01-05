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
extension UIImage {
    var base64: String? {
        self.jpegData(compressionQuality: 1)?.base64EncodedString()
    }
}

extension String {
    var imageFromBase64: UIImage? {
        guard let imageData = Data(base64Encoded: self, options: .ignoreUnknownCharacters) else {
            return nil
        }
        return UIImage(data: imageData)
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
