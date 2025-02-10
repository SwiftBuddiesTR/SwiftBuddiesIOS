import SwiftUI

struct PaginationView<Content: View>: View {
    let content: Content
    let isLoading: Bool
    let hasMorePages: Bool
    let onLoadMore: () async -> Void
    
    init(
        isLoading: Bool,
        hasMorePages: Bool,
        onLoadMore: @escaping () async -> Void,
        @ViewBuilder content: () -> Content
    ) {
        self.content = content()
        self.isLoading = isLoading
        self.hasMorePages = hasMorePages
        self.onLoadMore = onLoadMore
    }
    
    var body: some View {
        VStack(spacing: 8) {
            content
            
            if hasMorePages {
                ProgressView()
                    .frame(maxWidth: .infinity, alignment: .center)
                    .onAppear {
                        guard !isLoading else { return }
                        Task {
                            await onLoadMore()
                        }
                    }
            }
        }
    }
} 