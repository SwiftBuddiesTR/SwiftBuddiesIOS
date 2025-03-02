import SwiftUI

struct PaginatedListView<Content: View>: View {
    let state: FeedState
    let content: Content
    let onLoadMore: () async -> Void
    
    init(
        state: FeedState,
        @ViewBuilder content: () -> Content,
        onLoadMore: @escaping () async -> Void
    ) {
        self.state = state
        self.content = content()
        self.onLoadMore = onLoadMore
    }
    
    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 0) {
                content
                
                if shouldShowLoadingIndicator {
                    loadingIndicator
                }
            }
            .padding(.horizontal)
        }
    }
    
    private var shouldShowLoadingIndicator: Bool {
        switch state {
        case .loading(.nextPage), .loaded(hasMore: true):
            return true
        default:
            return false
        }
    }
    
    private var loadingIndicator: some View {
        HStack {
            Spacer()
            ProgressView()
                .onAppear {
                    Task {
                        await onLoadMore()
                    }
                }
            Spacer()
        }
        .padding()
    }
} 
