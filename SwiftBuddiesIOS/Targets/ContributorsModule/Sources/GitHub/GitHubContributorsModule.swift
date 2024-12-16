import SwiftUI
import BuddiesNetwork
import Network

public struct GitHubContributorsModule: ContributorsModuleProtocol {
    private let sessionConfiguration: URLSessionConfiguration
    
    public init(sessionConfiguration: URLSessionConfiguration = .default) {
        self.sessionConfiguration = sessionConfiguration
    }
    
    @MainActor
    public func makeContributorsView() -> GitHubContributorsView {
        let viewModel = makeViewModel()
        return GitHubContributorsView(viewModel: viewModel)
    }
    
    @MainActor 
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
