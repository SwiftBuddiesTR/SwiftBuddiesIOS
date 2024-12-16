//
//  File.swift
//  SwiftBuddiesMain
//
//  Created by dogukaan on 16.12.2024.
//  Copyright © 2024 SwiftBuddies. All rights reserved.
//

import SwiftUI
import Design

public struct GitHubContributorsView: View {
    @StateObject private var viewModel: GitHubContributorsViewModel
    
    public init(viewModel: GitHubContributorsViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    public var body: some View {
        Group {
            if viewModel.isLoading {
                ProgressView()
            } else if let error = viewModel.error {
                VStack {
                    Text("Error loading contributors")
                        .foregroundColor(.red)
                    Text(error.localizedDescription)
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Button("Retry") {
                        Task {
                            await viewModel.fetchContributors()
                        }
                    }
                    .buttonStyle(.bordered)
                }
            } else {
                List(viewModel.contributors) { contributor in
                    ContributorRow(contributor: contributor)
                }
            }
        }
        .navigationTitle("GitHub Contributors")
        .task(id: "fetchContributors") {
            await viewModel.fetchContributors()
        }
    }
}
