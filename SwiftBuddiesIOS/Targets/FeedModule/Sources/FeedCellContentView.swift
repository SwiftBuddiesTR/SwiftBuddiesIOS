//
//  FeedCellContentView.swift
//  Feed
//
//  Created by Kate Kashko on 15.04.2024.
//  Copyright © 2024 SwiftBuddies. All rights reserved.
//

import SwiftUI
import Design

struct FeedCellContentView: View {
    let post: PostModel
    
    var body: some View {
        // MARK: - post message
        Text(post.content)
            .frame(maxWidth: .infinity, alignment: .leading)
            .font(.footnote)
            .padding(.horizontal, 10)
            .padding(.top, 4)
        
        // MARK: - post image
        if let image = post.imageUrl, !image.isEmpty {
            Image(image, bundle: DesignResources.bundle)
                .resizable()
                .scaledToFit()
        }
    }
}

#Preview {
    FeedCellContentView(post: PostModel.MockPosts[0])
}
