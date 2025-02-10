import SwiftUI
import BuddiesNetwork
import Network

public struct BuddiesFeedModule: FeedModuleProtocol {
    private let sessionConfiguration: URLSessionConfiguration
    
    public init(sessionConfiguration: URLSessionConfiguration = .default) {
        self.sessionConfiguration = sessionConfiguration
    }
    
    @MainActor
    public func makeFeedView() -> BuddiesFeedView {
        let viewModel = makeViewModel()
        return BuddiesFeedView(viewModel: viewModel)
    }
    
    @MainActor 
    private func makeViewModel() -> BuddiesFeedViewModel {
        let client = makeNetworkClient()
        return BuddiesFeedViewModel(client: client)
    }
    
    private func makeNetworkClient() -> BuddiesClient {
        return .shared
    }
} 
