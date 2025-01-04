//
//  File.swift
//  Feed
//
//  Created by dogukaan on 4.01.2025.
//

import Foundation
import BuddiesNetwork
import Network

@MainActor
final class AddPostViewModel: ObservableObject {
    @Published var postContent: String = ""
    @Published var isLoading = false
    
    private let apiClient: BuddiesClient
    
    init() {
        self.apiClient = .shared
    }
    
    func createPost() async {
        guard !postContent.isEmpty else { return }
        
        isLoading = true
        defer { isLoading = false }
        
        let request = CreatePostRequest(content: postContent)
        
        do {
            let data = try await apiClient.perform(request)
            print("Post created: \(postContent), \(data.uid ?? "")")
//            for try await result in apiClient.watch(request, cachePolicy: .returnCacheDataAndFetch) {
//                print("Post created: \(postContent), \(result.uid ?? "")")
//            }
        } catch {
            print("Failed to create post: \(error)")
        }
    }
} 


// MARK: - FeedRequest
struct CreatePostRequest: Requestable {
    let content: String
    
    struct Data: Decodable {
        var uid: String?
    }
    
    func httpProperties() -> HTTPOperation<CreatePostRequest>.HTTPProperties {
        .init(
            url: APIs.Feed.createPost.url(),
            httpMethod: .post,
            data: self
        )
    }
}
