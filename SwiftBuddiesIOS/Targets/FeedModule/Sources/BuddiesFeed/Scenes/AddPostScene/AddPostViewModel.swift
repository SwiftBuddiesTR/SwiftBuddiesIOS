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
    @Published private(set) var error: String?
    
    let maxCharacterCount = 1000
    private let apiClient: BuddiesClient
    
    var isValid: Bool {
        !postContent.isEmpty && postContent.count <= maxCharacterCount && !isLoading
    }
    
    init() {
        self.apiClient = .shared
    }
    
    func createPost() async {
        guard isValid else { return }
        
        isLoading = true
        error = nil
        
        do {
            let request = CreatePostRequest(content: postContent)
            let response = try await apiClient.perform(request)
            
            if response.uid != nil {
                // Post created successfully
                postContent = ""
            } else {
                error = "Failed to create post"
            }
        } catch {
            self.error = error.localizedDescription
        }
        
        isLoading = false
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
