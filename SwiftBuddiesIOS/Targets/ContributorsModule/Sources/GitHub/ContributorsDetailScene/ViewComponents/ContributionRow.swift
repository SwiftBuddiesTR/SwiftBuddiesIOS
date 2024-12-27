//
//  File.swift
//  SwiftBuddiesMain
//
//  Created by dogukaan on 16.12.2024.
//  Copyright © 2024 SwiftBuddies. All rights reserved.
//

import SwiftUI

struct ContributionRow: View {
    let contribution: ContributorContribution
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: 8) {
                eventIcon
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(contribution.title)
                        .font(.subheadline)
                        .bold()
                        .lineLimit(2)
                    
                    if !contribution.description.isEmpty {
                        Text(contribution.description)
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .lineLimit(1)
                    }
                    
                    Text(contribution.createdAt ?? "")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
                
                Spacer(minLength: 0)
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.gray.opacity(0.1))
        )
    }
    
    private var eventIcon: some View {
        Image(systemName: iconName)
            .foregroundColor(iconColor)
    }
    
    private var iconName: String {
        switch contribution.type {
        case .push: "arrow.up.circle"
        case .pullRequest: "arrow.triangle.branch"
        case .pullRequestReview: "checkmark.circle"
        case .pullRequestReviewComment, .pullRequestReviewThread: "bubble.left"
        case .issue: "exclamationmark.circle"
        case .issueComment: "text.bubble"
        case .commitComment: "text.bubble.fill"
        case .create: "plus.circle"
        case .delete: "minus.circle"
        case .fork: "tuningfork"
        case .watch: "star"
        case .member: "person"
        case .release: "tag"
        case .sponsorship: "heart"
        case .gollum: "book"
        case .public: "lock.open"
        case .other: "circle.dotted"
        }
    }
    
    private var iconColor: Color {
        switch contribution.type {
        case .push: .blue
        case .pullRequest, .create: .green
        case .pullRequestReview: .purple
        case .pullRequestReviewComment, .pullRequestReviewThread: .cyan
        case .issue: .orange
        case .issueComment, .commitComment: .cyan
        case .delete: .red
        case .fork: .blue
        case .watch: .yellow
        case .member: .pink
        case .release: .mint
        case .sponsorship: .pink
        case .gollum: .indigo
        case .public: .green
        case .other: .secondary
        }
    }
} 
