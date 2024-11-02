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
class FeedViewModel: ObservableObject {
    @Published var posts: [PostModel]? 
    private let apiClient: BuddiesClient
    
    init() {
        self.apiClient = .shared
    }
    
    func fetchFeed() async {
        var request = FeedRequest(range: "0-2")
        
        do {
            let response = try await apiClient.perform(request)
            self.posts = response.feed?.map { postResponse in
                PostModel(
                    id: postResponse.post?.uid ?? "",
                    authorId: "", // Add authorId if available
                    likeCount: postResponse.post?.likeCount ?? 0,
                    commentsCount: postResponse.post?.commentCount ?? 0,
                    content: postResponse.post?.content ?? "",
                    imageUrl: postResponse.post?.images?.first ?? "",
                    user: UserModel(
                        id: UUID().uuidString,  // Use a unique ID
                        name: postResponse.user?.name ?? "",
                        profileImageUrl: postResponse.user?.picture
                    )
                )
            }
        } catch {
            print("Failed to fetch feed: \(error)")
        }
    }
}

// MARK: - FeedRequest
struct FeedRequest: Requestable {
    var range: String
    
    typealias Data = FeedResponse
    
    func toUrlRequest() throws -> URLRequest {
        // Construct the base URL with the endpoint
        try URLProvider.returnUrlRequest(
            method: .get,
            url: APIs.Feed.getFeed.url(),
            data: self
        )
    }
}
