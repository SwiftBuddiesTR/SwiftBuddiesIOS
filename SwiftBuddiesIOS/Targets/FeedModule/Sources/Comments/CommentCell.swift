//
//  CommentCell.swift
//  Feed
//
//  Created by Kate Kashko on 15.04.2024.
//  Copyright © 2024 SwiftBuddies. All rights reserved.
//

import SwiftUI

struct CommentCell: View {
    
    let post: PostModel
    var body: some View {
        HStack(spacing: 8){
            if let user = post.user{
                
                // MARK: - User photo
                
                Image(user.profileImageUrl)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 35, height: 35)
                    .clipShape(Circle())
                VStack(spacing: 8){
                    HStack(spacing: 8){
                        
                        // MARK: - User name
                        
                        Text(user.name)
                            .font(.body)
                            .fontWeight(.medium)
                        
                        // MARK: - Time
                        
                        Text("1 h") //need add logic
                            .font(.body)
                            .fontWeight(.regular)
                            .foregroundColor(.gray)
                        Spacer()
                    }
                    
                    // MARK: - Comment
                    
                    Text("Here will be comment. Here will be comment. ")
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                Spacer()
            }
        }
        .padding(.top, 10)
        .padding(.horizontal, 10)
    }
}

//#Preview {
//    CommentCell()
//}
