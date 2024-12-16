import SwiftUI

struct ContributionRow: View {
    let contribution: ContributorContribution
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(contribution.title)
                .font(.subheadline)
                .bold()
            
            Text(contribution.description)
                .font(.caption)
                .foregroundColor(.secondary)
            
            Text(contribution.date.formatted(date: .abbreviated, time: .omitted))
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(8)
    }
} 