//
//  File.swift
//  SwiftBuddiesMain
//
//  Created by dogukaan on 16.12.2024.
//  Copyright © 2024 SwiftBuddies. All rights reserved.
//

import SwiftUI
import BuddiesNetwork
import Network

@MainActor
public struct GitHubContributorsModule: @preconcurrency ContributorsModuleProtocol {
    private var contributorsView: GitHubContributorsView!
    private let sessionConfiguration: URLSessionConfiguration
    
    public init(sessionConfiguration: URLSessionConfiguration = .default) {
        self.sessionConfiguration = sessionConfiguration
        self.contributorsView = makeContributorsView()
    }
    
    public func getContributorsView() -> GitHubContributorsView {
        return contributorsView
    }
    
    private func makeContributorsView() -> GitHubContributorsView {
        let viewModel = makeViewModel()
        return GitHubContributorsView(viewModel: viewModel)
    }
    
    private func makeViewModel() -> GitHubContributorsViewModel {
        let client = makeNetworkClient()
        return GitHubContributorsViewModel(client: client)
    }
    
    private func makeNetworkClient() -> BuddiesClient {
        let interceptorProvider = GitHubInterceptorProvider(
            client: URLSessionClient(sessionConfiguration: sessionConfiguration)
        )
        
        return BuddiesClient(
            networkTransporter: BuddiesRequestChainNetworkTransport.getChainNetworkTransport(
                interceptorProvider: interceptorProvider
            )
        )
    }
}
