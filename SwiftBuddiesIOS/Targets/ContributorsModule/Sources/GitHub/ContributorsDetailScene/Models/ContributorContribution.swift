//
//  File.swift
//  SwiftBuddiesMain
//
//  Created by dogukaan on 16.12.2024.
//  Copyright © 2024 SwiftBuddies. All rights reserved.
//

import Foundation

struct ContributorContribution: Identifiable, Codable {
    let id: String
    let type: EventType
    let repo: Repository
    let createdAt: Date
    let payload: Payload
    
    struct Repository: Codable {
        let name: String
        let url: String
    }
    
    struct Payload: Codable {
        let action: String?
        let ref: String?
        let description: String?
    }
    
    enum EventType: Codable, Equatable {
        case push
        case pullRequest
        case pullRequestReview
        case pullRequestReviewComment
        case pullRequestReviewThread
        case issue
        case issueComment
        case commitComment
        case create
        case delete
        case fork
        case watch
        case member
        case release
        case sponsorship
        case gollum  // Wiki events
        case `public` // Repository made public
        case other(String)
        
        private var rawValue: String {
            switch self {
            case .push: return "PushEvent"
            case .pullRequest: return "PullRequestEvent"
            case .pullRequestReview: return "PullRequestReviewEvent"
            case .pullRequestReviewComment: return "PullRequestReviewCommentEvent"
            case .pullRequestReviewThread: return "PullRequestReviewThreadEvent"
            case .issue: return "IssuesEvent"
            case .issueComment: return "IssueCommentEvent"
            case .commitComment: return "CommitCommentEvent"
            case .create: return "CreateEvent"
            case .delete: return "DeleteEvent"
            case .fork: return "ForkEvent"
            case .watch: return "WatchEvent"
            case .member: return "MemberEvent"
            case .release: return "ReleaseEvent"
            case .sponsorship: return "SponsorshipEvent"
            case .gollum: return "GollumEvent"
            case .public: return "PublicEvent"
            case .other(let value): return value
            }
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            let rawValue = try container.decode(String.self)
            
            switch rawValue {
            case "PushEvent": self = .push
            case "PullRequestEvent": self = .pullRequest
            case "PullRequestReviewEvent": self = .pullRequestReview
            case "PullRequestReviewCommentEvent": self = .pullRequestReviewComment
            case "PullRequestReviewThreadEvent": self = .pullRequestReviewThread
            case "IssuesEvent": self = .issue
            case "IssueCommentEvent": self = .issueComment
            case "CommitCommentEvent": self = .commitComment
            case "CreateEvent": self = .create
            case "DeleteEvent": self = .delete
            case "ForkEvent": self = .fork
            case "WatchEvent": self = .watch
            case "MemberEvent": self = .member
            case "ReleaseEvent": self = .release
            case "SponsorshipEvent": self = .sponsorship
            case "GollumEvent": self = .gollum
            case "PublicEvent": self = .public
            default:
                self = .other(rawValue)
                print("⚠️ Unknown GitHub event type encountered: \(rawValue)")
            }
        }
        
        func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            try container.encode(rawValue)
        }
    }
    
    var title: String {
        switch type {
        case .push: return "Pushed to \(repo.name)"
        case .pullRequest: return "Pull Request in \(repo.name)"
        case .pullRequestReview: return "Reviewed PR in \(repo.name)"
        case .pullRequestReviewComment: return "Commented on PR in \(repo.name)"
        case .pullRequestReviewThread: return "Reviewed PR thread in \(repo.name)"
        case .issue: return "Issue in \(repo.name)"
        case .issueComment: return "Commented on issue in \(repo.name)"
        case .commitComment: return "Commented on commit in \(repo.name)"
        case .create: return "Created \(payload.ref ?? "") in \(repo.name)"
        case .delete: return "Deleted \(payload.ref ?? "") in \(repo.name)"
        case .fork: return "Forked \(repo.name)"
        case .watch: return "Starred \(repo.name)"
        case .member: return "Added as collaborator to \(repo.name)"
        case .release: return "Released in \(repo.name)"
        case .sponsorship: return "Sponsored \(repo.name)"
        case .gollum: return "Updated wiki in \(repo.name)"
        case .public: return "Made \(repo.name) public"
        case .other(let eventType): 
            return "\(eventType.replacingOccurrences(of: "Event", with: "")) in \(repo.name)"
        }
    }
    
    var description: String {
        payload.description ?? "Contributed to \(repo.name)"
    }
    
    enum CodingKeys: String, CodingKey {
        case id, type, repo, payload
        case createdAt = "created_at"
    }
} 
