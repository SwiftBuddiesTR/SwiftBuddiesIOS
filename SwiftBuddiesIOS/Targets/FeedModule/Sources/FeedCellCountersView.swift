//
//  FeedCellCountersView.swift
//  Feed
//
//  Created by Kate Kashko on 15.04.2024.
//  Copyright © 2024 SwiftBuddies. All rights reserved.
//

import SwiftUI

struct FeedCellCountersView: View {
    let post: PostModel
    
    var body: some View {
        HStack {
            // MARK: - Like counter
            Image(systemName: "heart")
            
            Text("\(post.likeCount)")
                .font(.footnote)
                .fontWeight(.medium)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            // MARK: - Comments counter
            Text("\(post.commentsCount) comments")
                .font(.footnote)
                .fontWeight(.regular)
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .padding(.top, 8)
        .padding(.horizontal, 10)
        .foregroundColor(.gray)
    }
}

#Preview {
    FeedCellCountersView(post: PostModel.MockPosts[0])
}
