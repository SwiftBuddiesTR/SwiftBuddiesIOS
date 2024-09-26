//
//  User.swift
//  Feed
//
//  Created by Kate Kashko on 8.04.2024.
//  Copyright © 2024 SwiftBuddies. All rights reserved.
//

import Foundation

struct UserModel: Identifiable, Hashable, Codable {
    let id: String
    let name: String
    let profileImageUrl: String
}

extension UserModel {
    static var MockUsers: [UserModel] = [
        .init(id: NSUUID().uuidString, name: "Tim Cook", profileImageUrl: "timcook"),
        .init(id: NSUUID().uuidString, name: "Tim Cook", profileImageUrl: "timcook"),
        .init(id: NSUUID().uuidString, name: "Tim Cook", profileImageUrl: "timcook")
    ]
}
