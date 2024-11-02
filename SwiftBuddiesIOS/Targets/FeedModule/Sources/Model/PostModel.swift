//
//  Post.swift
//  Feed
//
//  Created by Kate Kashko on 8.04.2024.
//  Copyright © 2024 SwiftBuddies. All rights reserved.
//

import Foundation

struct PostModel: Identifiable, Hashable, Codable {
    let id: String
    let authorId: String
    let likeCount: Int
    let commentsCount: Int
    let content: String
    let imageUrl: String?
    var user: UserModel?
    
    public init(id: String,
                authorId: String,
                likeCount: Int,
                commentsCount: Int,
                content: String,
                imageUrl: String?,
                user: UserModel?
    ) {
        self.id = id
        self.authorId = authorId
        self.likeCount = likeCount
        self.commentsCount = commentsCount
        self.content = content
        self.imageUrl = imageUrl
        self.user = user
    }
}

//extension PostModel {
//    static var MockPosts: [PostModel] = [
//        .init(
//            id: NSUUID().uuidString,
//            authorId: NSUUID().uuidString,
//            likeCount: 98,
//            commentsCount: 10,
//            content: "Lets do it...",
//            imageUrl: "example",
//            user: UserModel.MockUsers[0]
//        ),
//        .init(
//            id: NSUUID().uuidString,
//            authorId: NSUUID().uuidString,
//            likeCount: 123,
//            commentsCount: 15,
//            content: "Hello everyone",
//            imageUrl: "",
//            user: UserModel.MockUsers[0]
//        ),
//        .init(
//            id: NSUUID().uuidString,
//            authorId: NSUUID().uuidString,
//            likeCount: 120,
//            commentsCount: 20,
//            content: "Our first steps in project...",
//            imageUrl: "logo",
//            user: UserModel.MockUsers[0]
//        )
//        
//    ]
//}
