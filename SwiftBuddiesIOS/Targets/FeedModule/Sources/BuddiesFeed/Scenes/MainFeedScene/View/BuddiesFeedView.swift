//
//  File.swift
//  SwiftBuddiesIOS
//
//  Created by dogukaan on 19.12.2024.
//

import SwiftUI
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
                errorView(error)
            default:
                feedContent
            }
        }
        .refreshable {
            await viewModel.refresh()
        }
        .task {
            await viewModel.loadInitialContent()
        }
    }
    
    private var feedContent: some View {
        Group {
            PaginatedListView(state: viewModel.state) {
                ForEach(viewModel.posts, id: \.post.id) { post in
                    feedCell(for: post)
                }
            } onLoadMore: {
                await viewModel.loadMoreIfNeeded()
            }
        }
        .navigationTitle("Feed")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Image("logo", bundle: DesignResources.bundle)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 32)
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    coordinator.push(.addPost)
                }) {
                    Image(systemName: "plus.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                        .foregroundColor(.cyan)
                }
            }
        }
    }
    
}

extension BuddiesFeedView {
    @ViewBuilder
    private func errorView(_ error: FeedState.FeedError) -> some View {
        VStack {
            Text(error.localizedDescription)
                .multilineTextAlignment(.center)
                .padding()
            
            Button("Try Again") {
                Task {
                    await viewModel.refresh()
                }
            }
        }
    }

    @ViewBuilder
    private func feedCell(for feed: Post) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            // User info header
            HStack {
                Text(feed.user.name)
                    .fontWeight(.medium)
                    .onTapGesture {
                        coordinator.push(.userProfile(feed.user))
                    }
                Spacer()
                Text(feed.post.sharedDate)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            // Post content
            Text(feed.post.content ?? "")
            
            // Images
            if !feed.post.images.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(feed.post.images, id: \.self) { imageId in
                            if let uid = imageId, let image = viewModel.postImages[uid] {
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
            
            Divider()
        }
        .padding(.vertical, 8)
        .contentShape(Rectangle())
        .onTapGesture {
            coordinator.push(.postDetail(feed.post))
        }
    }
}
