import SwiftUI
import BuddiesNetwork
import Network

@MainActor
public class BuddiesFeedModule: @preconcurrency FeedModuleProtocol {
    private var feedView: BuddiesFeedView!
    private let sessionConfiguration: URLSessionConfiguration
    
    public init(sessionConfiguration: URLSessionConfiguration = .default) {
        self.sessionConfiguration = sessionConfiguration
        self.feedView = makeFeedView()
    }
    
    public func getFeedView() -> BuddiesFeedView {
        return feedView
    }
    
    private func makeFeedView() -> BuddiesFeedView {
        if let feedView = feedView {
            return feedView
        } else {
            let viewModel = makeViewModel()
            feedView = BuddiesFeedView(viewModel: viewModel)
            return feedView
        }
    }

    private func makeViewModel() -> BuddiesFeedViewModel {
        let client = makeNetworkClient()
        return BuddiesFeedViewModel(client: client)
    }
    
    private func makeNetworkClient() -> BuddiesClient {
        return .shared
    }
}
