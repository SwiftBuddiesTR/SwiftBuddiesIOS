//
//  File.swift
//  SwiftBuddiesIOS
//
//  Created by dogukaan on 2.03.2025.
//

import SwiftUI

// MARK: - Post Cell
public struct PostCell: View {

    public struct Data {
        var userId: String
        var userName: String
        var postId: String
        var date: String
        var content: String?
        var imageIds: [String?]
        var postImages: [String : UIImage]?
        var likeCount: Int
        var commentCount: Int
        var isLiked: Bool
        
        public init(
            userId: String,
            userName: String,
            postId: String,
            date: String,
            content: String?,
            imageIds: [String?],
            postImages: [String : UIImage]?,
            likeCount: Int = 0,
            commentCount: Int = 0,
            isLiked: Bool = false
        ) {
            self.userId = userId
            self.userName = userName
            self.postId = postId
            self.date = date
            self.content = content
            self.imageIds = imageIds
            self.postImages = postImages
            self.likeCount = likeCount
            self.commentCount = commentCount
            self.isLiked = isLiked
        }
    }
    
    private var post: Data
    private let onPostTap: (String) -> Void
    private let onUserTap: (String) -> Void
    private let onLikeTap: (String) -> Void
    private let onCommentTap: (String) -> Void
    
    public init(
        post: Data,
        onPostTap: @escaping (String) -> Void,
        onUserTap: @escaping (String) -> Void,
        onLikeTap: @escaping (String) -> Void = { _ in },
        onCommentTap: @escaping (String) -> Void = { _ in }
    ) {
        self.post = post
        self.onPostTap = onPostTap
        self.onUserTap = onUserTap
        self.onLikeTap = onLikeTap
        self.onCommentTap = onCommentTap
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // User info header
            PostHeader(
                userName: post.userName,
                date: post.date,
                onUserTap: {
                    onUserTap(post.userId)
                }
            )
            
            // Post content
            if let content = post.content,
                !content.isEmpty {
                Text(content)
            }
            
            // Images
            if let postImages = post.postImages,
                !postImages.isEmpty {
                PostImagesCarousel(
                    imageIds: post.imageIds,
                    postImages: postImages
                )
            }
            
            // Social action buttons
            HStack(spacing: 16) {
                SocialActionButton(
                    type: .like,
                    count: post.likeCount,
                    isSelected: .init(get: {
                        post.isLiked
                    }, set: { newValue in
                        onLikeTap(post.postId)
                    })
                )
                
                SocialActionButton(
                    type: .comment,
                    count: post.commentCount,
                    isSelected: .init(get: {
                        // isCommented flag
                        false
                    }, set: { newValue in
                        onCommentTap(post.postId)
                    })
                )
                
                Spacer()
            }
            .padding(.top, 4)
            
            Divider()
        }
        .padding(.vertical, 8)
        .contentShape(Rectangle())
        .onTapGesture {
            onPostTap(post.postId)
        }
    }
}

// MARK: - Post Header
struct PostHeader: View {
    let userName: String
    let date: String
    let onUserTap: () -> Void
    
    var body: some View {
        HStack {
            Text(userName)
                .fontWeight(.medium)
                .onTapGesture {
                    onUserTap()
                }
            Spacer()
            Text(date)
                .font(.caption)
                .foregroundColor(.gray)
        }
    }
}
