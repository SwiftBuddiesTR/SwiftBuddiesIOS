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
                    L.contributors_error_loading
                        .foregroundColor(.red)
                    Text(error.localizedDescription)
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Button(L.$button_retry.localized) {
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
        .navigationTitle(L.$contributors_github_title.localized)
        .task(id: "fetchContributors") {
            await viewModel.fetchContributors()
        }
    }
}
