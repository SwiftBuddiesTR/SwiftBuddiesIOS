//
//  File.swift
//  SwiftBuddiesMain
//
//  Created by dogukaan on 16.12.2024.
//  Copyright © 2024 SwiftBuddies. All rights reserved.
//

import Foundation

public struct Contributor: Identifiable, Equatable, Hashable {
    public let id: String
    public let name: String
    public let avatarURL: URL?
    public let githubURL: URL?
    public let contributions: Int
    
    public init(
        id: String,
        name: String,
        avatarURL: URL? = nil,
        githubURL: URL? = nil,
        contributions: Int = 0
    ) {
        self.id = id
        self.name = name
        self.avatarURL = avatarURL
        self.githubURL = githubURL
        self.contributions = contributions
    }
} 
