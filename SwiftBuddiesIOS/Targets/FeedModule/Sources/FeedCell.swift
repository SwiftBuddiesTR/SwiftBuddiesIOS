//
//  FeedViewCell.swift
//  Feed
//
//  Created by Kate Kashko on 8.04.2024.
//  Copyright © 2024 SwiftBuddies. All rights reserved.
//

import SwiftUI

struct FeedCell: View {
    let post: PostModel
    
    var body: some View {
        
        VStack {
            FeedCellHeaderView(post: post)
            FeedCellContentView(post: post)
            FeedCellCountersView(post: post)
            
            Divider()
            
            ActionButtonView()
        }
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 15))
    }
}

#Preview {
    FeedCell(post: PostModel.MockPosts[0])
}
