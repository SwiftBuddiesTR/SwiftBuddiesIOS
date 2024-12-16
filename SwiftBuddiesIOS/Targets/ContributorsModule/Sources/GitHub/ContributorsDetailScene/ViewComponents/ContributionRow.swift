import SwiftUI

struct ContributionRow: View {
    let contribution: ContributorContribution
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                eventIcon
                Text(contribution.title)
                    .font(.subheadline)
                    .bold()
            }
            
            if !contribution.description.isEmpty {
                Text(contribution.description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Text(contribution.createdAt.formatted(date: .abbreviated, time: .shortened))
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(8)
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
        case .issue: "exclamationmark.circle"
        case .create: "plus.circle"
        case .fork: "tuningfork"
        case .watch: "star"
        case .other: "circle"
        }
    }
    
    private var iconColor: Color {
        switch contribution.type {
        case .push: .blue
        case .pullRequest: .green
        case .pullRequestReview: .purple
        case .issue: .orange
        case .create: .green
        case .fork: .blue
        case .watch: .yellow
        case .other: .gray
        }
    }
} 
