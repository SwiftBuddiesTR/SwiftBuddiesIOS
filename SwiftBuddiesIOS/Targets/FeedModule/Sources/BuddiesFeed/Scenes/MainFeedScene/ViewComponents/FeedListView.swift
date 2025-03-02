//
//  File.swift
//  SwiftBuddiesIOS
//
//  Created by dogukaan on 2.03.2025.
//

import SwiftUI
import Design

// MARK: - Feed List View
struct FeedListView: View {
    let state: FeedState
    let posts: [Post]
    let postImages: [String: UIImage]
    let onPostTap: (String) -> Void
    let onUserTap: (String) -> Void
    let onLoadMore: () async -> Void
    
    var body: some View {
        PaginatedListView(state: state) {
            ForEach(posts, id: \.post.id) { post in
                PostCell(
                    post: .init(
                        userId: post.user.id,
                        userName: post.user.name,
                        postId: post.post.id,
                        date: post.post.sharedDate,
                        content: post.post.content,
                        imageIds: post.post.images,
                        postImages: postImages
                    ),
                    onPostTap: onPostTap,
                    onUserTap: onUserTap
                )
            }
        } onLoadMore: {
            await onLoadMore()
        }
    }
}
