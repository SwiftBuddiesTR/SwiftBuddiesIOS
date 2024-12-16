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
                HStack(alignment: .top) {
                    profileHeader
                    Spacer()
                    StatsLoadingView(
                        isLoading: viewModel.isStatsLoading,
                        content: { stats in
                            statsSection(stats)
                        }
                    )
                }
                .frame(maxWidth: .infinity)
                
                if let stats = viewModel.contributorStats {
                    userInfoSection(stats)
                }
                
                ActivitiesLoadingView(
                    isLoading: viewModel.isActivitiesLoading,
                    filters: viewModel.availableRepoFilters,
                    onFilterToggle: viewModel.toggleRepoFilter,
                    onClearFilters: viewModel.clearFilters,
                    content: { contributions in
                        contributionsList(contributions)
                    }
                )
                
                ScrollPositionIndicator(
                    coordinateSpace: "scroll",
                    onReachBottom: viewModel.fetchActivities
                )
            }
            .padding(.horizontal, 16)
        }
        .navigationTitle(viewModel.contributorStats?.name ?? contributor.name)
        .task(id: "fetchContributorDetails") {
            await viewModel.fetchContributorDetails()
        }
        .coordinateSpace(name: "scroll")
        .refreshable {
            await viewModel.refresh()
        }
    }
    
    private func contributionsList(_ contributions: [ContributorContribution]) -> some View {
        LazyVStack(spacing: 8) {
            ForEach(contributions) { contribution in
                ContributionRow(contribution: contribution)
                    .frame(maxWidth: .infinity)
            }
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
            HStack(spacing: 16) {
                StatView(title: "Contributions", value: "\(contributor.contributions)")
                StatView(title: "Repos", value: "\(stats.publicRepos)")
            }
            HStack(spacing: 16) {
                StatView(title: "Followers", value: "\(stats.followers)")
                StatView(title: "Following", value: "\(stats.following)")
            }
        }
        .padding(.vertical)
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

// Loading wrapper views
private struct StatsLoadingView<Content: View>: View {
    let isLoading: Bool
    let content: (ContributorStats) -> Content
    @State private var stats: ContributorStats?
    
    var body: some View {
        if isLoading && stats == nil {
            ProgressView()
        } else if let stats {
            content(stats)
                .transition(.opacity)
        }
    }
}

private struct ActivitiesLoadingView<Content: View>: View {
    let isLoading: Bool
    let filters: [RepoFilter]
    let onFilterToggle: (RepoFilter) -> Void
    let onClearFilters: () -> Void
    let content: ([ContributorContribution]) -> Content
    @State private var contributions: [ContributorContribution] = []
    
    var body: some View {
        VStack(spacing: 8) {
            if !filters.isEmpty {
                RepoFilterView(
                    filters: filters,
                    onFilterToggle: onFilterToggle,
                    onClearFilters: onClearFilters
                )
            }
            
            if isLoading && contributions.isEmpty {
                ProgressView()
            } else {
                content(contributions)
                    .transition(.opacity)
            }
        }
    }
}
