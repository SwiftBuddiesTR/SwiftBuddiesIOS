//
//  File.swift
//  SwiftBuddiesIOS
//
//  Created by dogukaan on 19.12.2024.
//

import SwiftUI
// If Design module is not available, you might need to create it or import the correct module
 import Design

public struct BuddiesFeedView: View {
    @ObservedObject private var viewModel: BuddiesFeedViewModel
    @EnvironmentObject private var coordinator: BuddiesFeedCoordinator
    
    init(viewModel: BuddiesFeedViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        Group {
            switch viewModel.state {
            case .error(let error):
                FeedErrorView(error: error, onRetry: {
                    Task {
                        await viewModel.refresh()
                    }
                })
            default:
                FeedContentView(
                    viewModel: viewModel,
                    coordinator: coordinator
                )
            }
        }
        .refreshable {
            await viewModel.refresh()
        }
        .task {
            await viewModel.loadInitialContent()
        }
    }
}
