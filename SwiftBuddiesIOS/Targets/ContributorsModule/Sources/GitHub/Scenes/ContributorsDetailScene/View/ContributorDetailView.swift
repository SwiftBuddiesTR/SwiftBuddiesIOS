//
//  File.swift
//  SwiftBuddiesMain
//
//  Created by dogukaan on 16.12.2024.
//  Copyright © 2024 SwiftBuddies. All rights reserved.
//

import SwiftUI
import Design
import Localization

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
                        .padding(.vertical, 8)
                }
                
                ActivitiesLoadingView(
                    isLoading: viewModel.isActivitiesLoading,
                    filters: viewModel.availableRepoFilters,
                    onFilterToggle: viewModel.toggleRepoFilter,
                    onClearFilters: viewModel.clearFilters,
                    content: { contributions in
                        contributionsList(contributions)
                    },
                    contributions: Array(viewModel.recentContributions ?? [])
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
        LazyVStack(spacing: 12) {
            ForEach(contributions) { contribution in
                ContributionRow(contribution: contribution)
            }
            
            if viewModel.isActivitiesLoading {
                ProgressView()
                    .padding()
            }
        }
        .frame(maxWidth: .infinity)
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
                StatView(title: L.$contributors_followers.localized, value: "\(stats.followers)")
                StatView(title: L.$contributors_following.localized, value: "\(stats.following)")
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
            L.contributors_open_in_github
        }
        .buttonStyle(
            BuddiesButtonStyle(
                style: .secondary(color: .accentColor),
                width: .hug,
                size: .medium,
                shape: .roundedRectangle,
                role: .default,
                leadingIcon: Image(systemName: "link")
            )
        )
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
    let contributions: [ContributorContribution]
    
    var body: some View {
        VStack(spacing: 16) {
            // Section Header with Filter Button
            HStack {
                L.contributors_recent_activities
                    .font(.title3)
                    .bold()
                
                Spacer()
                
                if !filters.isEmpty {
                    Menu {
                        ForEach(filters) { filter in
                            Button(action: { onFilterToggle(filter) }) {
                                HStack {
                                    Text(filter.name)
                                    if filter.isSelected {
                                        Image(systemName: "checkmark")
                                    }
                                }
                            }
                        }
                        
                        Divider()
                        
                        Button(role: .destructive, action: onClearFilters) {
                            Text(L.$contributors_clear_filters.localized)
                        }
                    } label: {
                        HStack(spacing: 4) {
                            L.contributors_filter
                            Image(systemName: "line.3.horizontal.decrease.circle")
                        }
                        .foregroundStyle(filters.contains(where: \.isSelected) ? .blue : .secondary)
                    }
                }
            }
            
            // Active Filters
            if !filters.isEmpty && filters.contains(where: \.isSelected) {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(filters.filter(\.isSelected)) { filter in
                            HStack(spacing: 4) {
                                Text(filter.name)
                                    .font(.caption)
                                Button {
                                    onFilterToggle(filter)
                                } label: {
                                    Image(systemName: "xmark.circle.fill")
                                        .font(.caption)
                                }
                            }
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(
                                Capsule()
                                    .fill(Color.blue.opacity(0.1))
                            )
                            .overlay(
                                Capsule()
                                    .strokeBorder(Color.blue.opacity(0.3), lineWidth: 1)
                            )
                        }
                    }
                    .padding(.horizontal, 4)
                }
            }
            
            // Content
            if isLoading && contributions.isEmpty {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .frame(height: 200)
            } else if contributions.isEmpty {
                VStack(spacing: 8) {
                    Image(systemName: "doc.text.image")
                        .font(.largeTitle)
                        .foregroundStyle(.secondary)
                    Text(L.common_no_recent_activities)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 200)
            } else {
                content(contributions)
                    .transition(.opacity)
            }
        }
    }
}
