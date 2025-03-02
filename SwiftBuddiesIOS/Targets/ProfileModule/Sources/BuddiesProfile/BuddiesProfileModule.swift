//
//  BuddiesProfileModule.swift
//  SwiftBuddiesIOS
//
//  Created by dogukaan on 2.03.2025.
//

import SwiftUI
import BuddiesNetwork
import Network

@MainActor
public class BuddiesProfileModule: @preconcurrency ProfileModuleProtocol {
    private var profileView: BuddiesProfileView!
    private let sessionConfiguration: URLSessionConfiguration
    
    public init(sessionConfiguration: URLSessionConfiguration = .default) {
        self.sessionConfiguration = sessionConfiguration
        self.profileView = makeProfileView()
    }
    
    public func getProfileView() -> BuddiesProfileView {
        return profileView
    }
    
    private func makeProfileView() -> BuddiesProfileView {
        let viewModel = makeViewModel()
        return BuddiesProfileView(viewModel: viewModel)
    }
    
    private func makeViewModel() -> BuddiesProfileViewModel {
        let client = makeNetworkClient()
        return BuddiesProfileViewModel(client: client)
    }
    
    private func makeNetworkClient() -> BuddiesClient {
        return .shared
    }
}
    
