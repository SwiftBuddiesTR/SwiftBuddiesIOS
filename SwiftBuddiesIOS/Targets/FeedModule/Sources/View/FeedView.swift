import SwiftUI
import Design

public struct FeedView: View {
    @StateObject private var viewModel = FeedViewModel()
    @State private var addPost = false
    
    public init() {}
    public var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 10) {
                    if let posts = viewModel.posts {
                        ForEach(posts) { post in
                            FeedCell(post: post)
                        }
                    }
                }
                .padding(.top, 20)
                .padding(.horizontal, 12)
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
                        addPost.toggle()
                    }) {
                        Image(systemName: "plus.circle")
                            .resizable()
                            .renderingMode(.template)
                            .scaledToFill()
                            .frame(width: 24, height: 24)
                            .foregroundColor(Color.cyan)
                    }
                }
            }
            // TODO: here will be custom color
            .background(Color(CGColor(gray: 0.9, alpha: 0.5)))
            .sheet(isPresented: $addPost) {
                AddPostView()
            }
            .task {
                await viewModel.fetchFeed()
            }
        }
    }
}

#Preview {
    FeedView()
}
