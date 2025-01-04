import SwiftUI

struct PaginatedListView<Content: View>: View {
    let content: Content
    let state: FeedState
    let onLoadMore: () async -> Void
    
    init(
        state: FeedState,
        @ViewBuilder content: () -> Content,
        onLoadMore: @escaping () async -> Void
    ) {
        self.content = content()
        self.state = state
        self.onLoadMore = onLoadMore
    }
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                content
                
                if case let .loaded(hasMore) = state, hasMore {
                    loadingCell
                }
                
                if case .loading(let type) = state {
                    loadingIndicator(for: type)
                }
            }
            .padding(.horizontal)
        }
    }
    
    private var loadingCell: some View {
        ProgressView()
            .frame(height: 20)
            .onAppear {
                Task {
                    await onLoadMore()
                }
            }
    }
    
    @ViewBuilder
    private func loadingIndicator(for type: FeedState.LoadingType) -> some View {
        ProgressView()
            .frame(maxWidth: .infinity)
            .padding()
    }
} 
