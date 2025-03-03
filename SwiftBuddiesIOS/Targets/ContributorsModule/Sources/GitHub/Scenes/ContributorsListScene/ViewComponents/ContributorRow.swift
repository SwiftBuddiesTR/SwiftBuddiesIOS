//
//  File.swift
//  SwiftBuddiesMain
//
//  Created by dogukaan on 16.12.2024.
//  Copyright © 2024 SwiftBuddies. All rights reserved.
//

import SwiftUI
import Localization

struct ContributorRow: View {
    @EnvironmentObject private var coordinator: GitHubContributorsCoordinator
    let contributor: Contributor
    
    var body: some View {
        Button {
            coordinator.push(.detail(contributor))
        } label: {
            HStack {
                if let avatarURL = contributor.avatarURL {
                    AsyncImage(url: avatarURL) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    } placeholder: {
                        Circle()
                            .foregroundColor(.gray.opacity(0.3))
                    }
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
                }
                
                VStack(alignment: .leading) {
                    Text(contributor.name)
                        .font(.headline)
                    Text(L.$contributors_contributions_count.format(contributor.contributions))
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.secondary)
            }
        }
        .buttonStyle(.plain)
        .padding(.vertical, 4)
    }
} 
