//
//  FeedCellHeaderView.swift
//  Feed
//
//  Created by Kate Kashko on 15.04.2024.
//  Copyright © 2024 SwiftBuddies. All rights reserved.
//

import SwiftUI
import Design

struct FeedCellHeaderView: View {
    let post: PostModel
    
    var body: some View {
        HStack {
            if let user = post.user {
                // MARK: - User photo
                Image(user.profileImageUrl, bundle: DesignResources.bundle)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 43, height: 43)
                    .clipShape(Circle())
                
                VStack {
                    // MARK: - User name
                    Text(user.name)
                        .font(.body)
                        .fontWeight(.medium)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Spacer()
                    // MARK: - Date of publication of the post
                    Text("01.01.2025 at 09.00 a.m.") //need add logic
                        .font(.caption2)
                        .fontWeight(.regular)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(.gray)
                }
                .frame(maxHeight: 43)
            }
            Spacer()
        }
        .padding(.top, 10)
        .padding(.horizontal, 10)
    }
}

#Preview {
    FeedCellHeaderView(post: PostModel.MockPosts[0])
}
