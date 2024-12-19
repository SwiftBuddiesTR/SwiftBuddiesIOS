//
//  File.swift
//  SwiftBuddiesIOS
//
//  Created by dogukaan on 19.12.2024.
//

import SwiftUI
import Design

public struct BuddiesFeedView: View {
    @StateObject private var viewModel = BuddiesFeedViewModel()
    @ObservedObject private var coordinator: BuddiesFeedCoordinator
    
    init(coordinator: BuddiesFeedCoordinator) {
        self.coordinator = coordinator
    }
    
    public var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(viewModel.posts, id: \.post.uid) { feed in
                    feedCell(for: feed)
                        .onAppear {
                            // Trigger pagination when last item appears
                            if feed.post.uid == viewModel.posts.last?.post.uid {
                                Task {
                                    await viewModel.fetchFeed()
                                }
                            }
                        }
                }
                
                if viewModel.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity)
                        .padding()
                }
            }
            .padding(.horizontal)
        }
        .refreshable {
            await viewModel.fetchFeed(isRefreshing: true)
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
        .task {
            if viewModel.posts.isEmpty {
                await viewModel.fetchFeed()
            }
        }
    }
    
    @ViewBuilder
    private func feedCell(for feed: Feed) -> some View {
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
                .onTapGesture {
                    coordinator.push(.postDetail(feed.post))
                }
            
            Divider()
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    NavigationStack {
        BuddiesFeedView(coordinator: BuddiesFeedCoordinator())
    }
}
