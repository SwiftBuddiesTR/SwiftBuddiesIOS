//
//  File.swift
//  Feed
//
//  Created by dogukaan on 4.01.2025.
//

import Foundation
import BuddiesNetwork
import Network
import UIKit

@MainActor
final class AddPostViewModel: ObservableObject {
    @Published var postContent: String = ""
    @Published var isLoading = false
    @Published private(set) var error: String?
    @Published var selectedImages: [PostImage] = []
    
    let maxCharacterCount = 1000
    let maxImages = 4
    var isValid: Bool {
        (!postContent.isEmpty || !selectedImages.isEmpty) &&
        postContent.count <= maxCharacterCount &&
        !isLoading &&
        !hasUploadingImages
    }
    
    private var hasUploadingImages: Bool {
        selectedImages.contains { !$0.isUploaded }
    }
    
    var canAddMoreImages: Bool {
        selectedImages.count < maxImages
    }

    private let apiClient: BuddiesClient
    
    init(apiClient: BuddiesClient = .shared) {
        self.apiClient = apiClient
    }
    
    func removeImage(with id: String) {
        selectedImages.removeAll(where: { $0.id == id })
    }
    
    func handleNewImages() async {
        await uploadPendingImages()
    }
    
    private func uploadPendingImages() async {
        // Create a task group to handle concurrent uploads
        await withTaskGroup(of: Void.self) { group in
            for index in selectedImages.indices where !selectedImages[index].isUploaded {
                group.addTask { [weak self] in
                    await self?.uploadImage(at: index)
                }
            }
        }
    }
    
    private func uploadImage(at index: Int) async {
        guard !selectedImages[index].isUploading else { return }
        guard index < selectedImages.count else { return }
        
        selectedImages[index].isUploading = true
        selectedImages[index].error = nil
        
        do {
            guard let base64 = selectedImages[index].data?.base64EncodedString() else {
                selectedImages[index].error = "Failed to get base64 value"
                return
            }
            let request = UploadImageRequest(
                base64: "data:image/heic;base64,\(base64)"
            )
            
            let response = try await apiClient.perform(request)
            
            if let imageId = response.id {
                selectedImages[index].id = imageId
                selectedImages[index].isUploaded = true
            } else {
                selectedImages[index].error = "Failed to upload image"
            }
        } catch {
            selectedImages[index].error = error.localizedDescription
        }
        
        selectedImages[index].isUploading = false
    }
    
    func createPost() async {
        guard isValid else { return }
        
        // Ensure all images are uploaded before creating post
        if !selectedImages.isEmpty {
            await uploadPendingImages()
            
            // Check if any uploads failed
            if hasUploadingImages {
                error = "Some images failed to upload"
                return
            }
        }
        
        isLoading = true
        error = nil
        
        do {
            let request = CreatePostRequest(
                content: postContent,
                images: selectedImages.map(\.id)
            )
            let response = try await apiClient.perform(request)
            
            if response.uid != nil {
                postContent = ""
                selectedImages.removeAll()
            } else {
                error = "Failed to create post"
            }
        } catch {
            self.error = error.localizedDescription
        }
        
        isLoading = false
    }
}
///    ## Upload Image
///      - **Endpoint**: POST /api/uploadImage
///     - **Authentication**: Required (Bearer token)
///     - **Request Body**:
///
/// ```json
/// {
///     "base64": "data:image/jpeg;base64,/9j/4AAQSkZJRg...",
///     "isPrivate": false
/// }
/// ```
/// - **Response**:
/// ```json
/// {
///     "uid": "image-uid-here"
/// }
/// ```
struct UploadImageRequest: Requestable {
    let base64: String
    
    struct Data: Decodable {
        var id: String?
        
        enum CodingKeys: String, CodingKey {
            case id = "uid"
        }
    }
    
    func httpProperties() -> HTTPOperation<UploadImageRequest>.HTTPProperties {
        .init(
            url: APIs.Feed.uploadImage.url(.prodV2),
            httpMethod: .post,
            data: self
        )
    }
}

// MARK: - Request Types
struct CreatePostRequest: Requestable {
    let content: String
    let images: [String]
    
    struct Data: Decodable {
        var uid: String?
    }
    
    func httpProperties() -> HTTPOperation<Self>.HTTPProperties {
        .init(
            url: APIs.Feed.createPost.url(),
            httpMethod: .post,
            data: self
        )
    }
}
