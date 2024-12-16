import SwiftUI
import Design

struct ContributorDetailView: View {
    let contributor: Contributor
    @StateObject private var viewModel: ContributorDetailViewModel
    
    init(contributor: Contributor) {
        self.contributor = contributor
        _viewModel = StateObject(wrappedValue: ContributorDetailViewModel(contributor: contributor))
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Profile Header
                profileHeader
                
                // Stats Section
                statsSection
                
                // Contributions Section
                if viewModel.isLoading {
                    ProgressView()
                } else {
                    contributionsSection
                }
                
                // GitHub Link Button
                githubLinkButton
            }
            .padding()
        }
        .navigationTitle(contributor.name)
        .task {
            await viewModel.fetchContributorDetails()
        }
    }
    
    private var profileHeader: some View {
        VStack {
            if let avatarURL = contributor.avatarURL {
                AsyncImage(url: avatarURL) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Circle()
                        .foregroundColor(.gray.opacity(0.3))
                }
                .frame(width: 120, height: 120)
                .clipShape(Circle())
                .shadow(radius: 5)
            }
            
            Text(contributor.name)
                .font(.title2)
                .bold()
        }
    }
    
    private var statsSection: some View {
        HStack(spacing: 40) {
            StatView(title: "Contributions", value: "\(contributor.contributions)")
            if let stats = $viewModel.contributorStats {
                StatView(title: "Repositories", value: "\(stats.repositories)")
                StatView(title: "Followers", value: "\(stats.followers)")
            }
        }
        .padding(.vertical)
    }
    
    private var contributionsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Recent Contributions")
                .font(.headline)
            
            if let contributions = $viewModel.recentContributions {
                ForEach(contributions) { contribution in
                    ContributionRow(contribution: contribution)
                }
            } else {
                Text("No recent contributions found")
                    .foregroundColor(.secondary)
            }
        }
    }
    
    private var githubLinkButton: some View {
        Button {
            if let url = contributor.githubURL {
                UIApplication.shared.open(url)
            }
        } label: {
            Label("Open in GitHub", systemImage: "link")
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.bordered)
        .tint(.primary)
    }
}
