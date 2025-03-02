//
//  File.swift
//  SwiftBuddiesIOS
//
//  Created by dogukaan on 19.12.2024.
//

import SwiftUI
// If Design module is not available, you might need to create it or import the correct module
 import Design

public struct BuddiesFeedView: View {
    @ObservedObject private var viewModel: BuddiesFeedViewModel
    @EnvironmentObject private var coordinator: BuddiesFeedCoordinator
    
    init(viewModel: BuddiesFeedViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        Group {
            switch viewModel.state {
            case .error(let error):
                FeedErrorView(error: error, onRetry: {
                    Task {
                        await viewModel.refresh()
                    }
                })
            default:
                FeedContentView(
                    viewModel: viewModel,
                    coordinator: coordinator
                )
            }
        }
        .refreshable {
            await viewModel.refresh()
        }
        .task {
            await viewModel.loadInitialContent()
        }
    }
}

// MARK: - Feed Content View
struct FeedContentView: View {
    @ObservedObject var viewModel: BuddiesFeedViewModel
    let coordinator: BuddiesFeedCoordinator
    
    var body: some View {
        FeedListView(
            state: viewModel.state,
            posts: viewModel.posts,
            postImages: viewModel.postImages,
            onPostTap: { post in
                coordinator.push(.postDetail(post))
            },
            onUserTap: { user in
                coordinator.push(.userProfile(user))
            },
            onLoadMore: {
                await viewModel.loadMoreIfNeeded()
            }
        )
        .navigationTitle("Feed")
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

// MARK: - Feed List View
struct FeedListView: View {
    let state: FeedState
    let posts: [Post]
    let postImages: [String: UIImage]
    let onPostTap: (Post) -> Void
    let onUserTap: (FeedUser) -> Void
    let onLoadMore: () async -> Void
    
    var body: some View {
        PaginatedListView(state: state) {
            ForEach(posts, id: \.post.id) { post in
                PostCell(
                    post: post,
                    postImages: postImages,
                    onPostTap: { onPostTap(post) },
                    onUserTap: { onUserTap(post.user) }
                )
            }
        } onLoadMore: {
            await onLoadMore()
        }
    }
}

// MARK: - Post Cell
struct PostCell: View {
    let post: Post
    let postImages: [String: UIImage]
    let onPostTap: () -> Void
    let onUserTap: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // User info header
            PostHeader(
                userName: post.user.name,
                date: post.post.sharedDate,
                onUserTap: onUserTap
            )
            
            // Post content
            if let content = post.post.content, !content.isEmpty {
                Text(content)
            }
            
            // Images
            if !post.post.images.isEmpty {
                PostImagesCarousel(
                    imageIds: post.post.images,
                    postImages: postImages
                )
            }
            
            Divider()
        }
        .padding(.vertical, 8)
        .contentShape(Rectangle())
        .onTapGesture {
            onPostTap()
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

// MARK: - Post Images Carousel
struct PostImagesCarousel: View {
    let imageIds: [String?]
    let postImages: [String: UIImage]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(imageIds.compactMap { $0 }, id: \.self) { imageId in
                    if let image = postImages[imageId] {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 200, height: 200)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    } else {
                        ProgressView()
                            .frame(width: 200, height: 200)
                    }
                }
            }
        }
    }
}

// MARK: - Error View
struct FeedErrorView: View {
    let error: FeedState.FeedError
    let onRetry: () -> Void
    
    var body: some View {
        VStack {
            Text(error.localizedDescription)
                .multilineTextAlignment(.center)
                .padding()
            
            Button("Try Again", action: onRetry)
        }
    }
}

// MARK: - UI Components
struct LogoView: View {
    var body: some View {
        // If Design module is not available, you might need to adjust this
        Image("logo", bundle: DesignResources.bundle) // Replace with DesignResources.bundle when available
            .resizable()
            .scaledToFill()
            .frame(width: 100, height: 32)
    }
}

struct AddPostButton: View {
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: "plus.circle")
                .resizable()
                .scaledToFit()
                .frame(width: 24, height: 24)
                .foregroundColor(.cyan)
        }
    }
}
