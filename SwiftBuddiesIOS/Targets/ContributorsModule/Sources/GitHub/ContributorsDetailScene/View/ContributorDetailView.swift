//
//  File.swift
//  SwiftBuddiesMain
//
//  Created by dogukaan on 16.12.2024.
//  Copyright © 2024 SwiftBuddies. All rights reserved.
//

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
            VStack(spacing: 8) {
                Group {
                    HStack(alignment: .top) {
                        profileHeader
                        Spacer()
                        if viewModel.isLoading {
                            ProgressView()
                        } else {
                            if let stats = viewModel.contributorStats {
                                statsSection(stats)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
                    if let stats = viewModel.contributorStats {
                        userInfoSection(stats)
                    }
                }
                .padding(.horizontal, 16)
                
                if viewModel.isLoading {
                    ProgressView()
                } else {
                    if !viewModel.availableRepoFilters.isEmpty {
                        RepoFilterView(
                            filters: viewModel.availableRepoFilters,
                            onFilterToggle: viewModel.toggleRepoFilter,
                            onClearFilters: viewModel.clearFilters
                        )
                    } else {
                        Text("No repositories found")
                            .foregroundColor(.secondary)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .font(.subheadline)
                    }
                    recentActivitiesSection
                        .padding(.horizontal, 16)
                }
            }
        }
        .navigationTitle(viewModel.contributorStats?.name ?? contributor.name)
        .task(id: "fetchContributorDetails") {
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
                .frame(height: 120)
                .clipShape(Circle())
                .shadow(radius: 5)
            }
            
            Text(contributor.name)
                .font(.title2)
                .bold()
            githubLinkButton
        }
        .frame(width: 140)
    }
    
    private func userInfoSection(_ stats: ContributorStats) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            if let bio = stats.bio {
                Text(bio)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                if let company = stats.company {
                    Label(company, systemImage: "building.2")
                }
                if let location = stats.location {
                    Label(location, systemImage: "location")
                }
                if let blog = stats.blog {
                    Link(destination: URL(string: blog) ?? URL(string: "https://github.com")!) {
                        Label(blog, systemImage: "link")
                    }
                }
            }
            .font(.caption)
            .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private func statsSection(_ stats: ContributorStats) -> some View {
        VStack(spacing: 8) {
           HStack {
                StatView(title: "Contributions", value: "\(contributor.contributions)")
                StatView(title: "Repositories", value: "\(stats.publicRepos)")
            }   
            HStack {
                StatView(title: "Followers", value: "\(stats.followers)")
                StatView(title: "Following", value: "\(stats.following)")
            }
        }
        .padding(.vertical)
    }
    
    private var recentActivitiesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Recent Activities")
                .font(.headline)
            
            if let contributions = viewModel.recentContributions {
                if contributions.isEmpty {
                    Text("No recent activities")
                        .foregroundColor(.secondary)
                } else {
                    ForEach(contributions) { contribution in
                        ContributionRow(contribution: contribution)
                    }
                }
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
                .font(.footnote)
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.bordered)
        .tint(.primary)
    }
}
