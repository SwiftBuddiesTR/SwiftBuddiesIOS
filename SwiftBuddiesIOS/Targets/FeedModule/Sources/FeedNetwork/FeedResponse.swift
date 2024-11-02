//
//  FeedResponse.swift
//  SwiftBuddiesIOS
//
//  Created by Kate Kashko on 1.11.2024.
//

import Foundation

struct FeedResponse: Codable {
    let feed: [PostResponse]?
}

struct PostResponse: Codable {
    let user: UserResponse?
    let post: PostDataResponse?
}

struct UserResponse: Codable {
    let name: String?
    let picture: String?
}

struct PostDataResponse: Codable {
    let uid: String
    let sharedDate: String
    let content: String
    let images: [String]?
    let likeCount: Int
    let commentCount: Int
}

