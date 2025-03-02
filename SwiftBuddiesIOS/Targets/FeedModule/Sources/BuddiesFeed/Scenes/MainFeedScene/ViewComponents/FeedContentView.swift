//
//  File.swift
//  SwiftBuddiesIOS
//
//  Created by dogukaan on 2.03.2025.
//

import SwiftUI
import Design
import Localization

// MARK: - Feed Content View
struct FeedContentView: View {
    @ObservedObject var viewModel: BuddiesFeedViewModel
    let coordinator: BuddiesFeedCoordinator
    
    var body: some View {
        FeedListView(
            state: viewModel.state,
            posts: viewModel.posts,
            postImages: viewModel.postImages,
            onPostTap: { postId in
                coordinator.push(.postDetail(postId))
            },
            onUserTap: { userId in
                coordinator.push(.userProfile(userId))
            },
            onLoadMore: {
                await viewModel.loadMoreIfNeeded()
            }
        )
        .navigationTitle(L.$feed_title.localized)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                LogoView()
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                AddPostButton {
                    coordinator.push(.addPost)
                }
            }
        }
    }
}
