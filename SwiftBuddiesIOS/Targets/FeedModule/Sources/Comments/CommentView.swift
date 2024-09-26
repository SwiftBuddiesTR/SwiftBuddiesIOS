//
//  CommentView.swift
//  Feed
//
//  Created by Kate Kashko on 15.04.2024.
//  Copyright © 2024 SwiftBuddies. All rights reserved.
//

import SwiftUI

struct CommentView: View {
    
    var body: some View {
        NavigationStack{
            VStack{
                ScrollView{
                    LazyVStack(spacing: 12) {
                        ForEach(PostModel.MockPosts) { post in
                            CommentCell(post: post)
                        }
                    }
                    .padding(.top, 20)
                    .padding(.horizontal, 12)
                }
                .navigationTitle("Comments")
                .navigationBarTitleDisplayMode(.inline)
            }
            
            AddCommentView()
        }
        .onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
}

#Preview {
    CommentView()
}
