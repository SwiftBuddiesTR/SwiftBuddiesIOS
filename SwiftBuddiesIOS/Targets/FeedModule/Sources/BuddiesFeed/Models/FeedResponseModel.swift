//
//  File.swift
//  SwiftBuddiesIOS
//
//  Created by dogukaan on 19.12.2024.
//

import Foundation

// MARK: - FeedResponse
struct FeedResponseModel: Decodable {
    var feed: [Post]?
}

// MARK: - Feed
struct Post: Decodable, Hashable {
    var user: FeedUser
    var post: FeedPost
}

// MARK: - Post
struct FeedPost: Decodable, Identifiable, Equatable, Hashable {
    static func == (lhs: FeedPost, rhs: FeedPost) -> Bool {
        lhs.uid == rhs.uid
    }
    
    var uid: String
    var sharedDate: String
    var content: String?
    var images: [String?]
    var likeCount: Int
    var isLiked: Bool
    var likers: [FeedLiker]?
    var commentCount: Int
    var hashtags: [String]
    
    var id: String {
        uid
    }
}

// MARK: - Liker
struct FeedLiker: Decodable, Identifiable, Equatable, Hashable {
    var name: String
    var picture: String
    var uid: String?
    var isSelf: Bool
    
    var id: String {
        uid ?? UUID().uuidString
    }
}

// MARK: - User
struct FeedUser: Decodable, Identifiable, Equatable, Hashable {
    var uid: String?
    var name: String
    var picture: String
    
    var id: String {
        uid ?? UUID().uuidString
    }
}
