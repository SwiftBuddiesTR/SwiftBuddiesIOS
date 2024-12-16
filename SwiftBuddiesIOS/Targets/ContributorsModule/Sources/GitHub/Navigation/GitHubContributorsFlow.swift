import SwiftUI

struct GitHubContributorsFlow: View {
    @StateObject private var coordinator: GitHubContributorsCoordinator
    private let module: GitHubContributorsModule
    
    init(module: GitHubContributorsModule = GitHubContributorsModule()) {
        self._coordinator = StateObject(wrappedValue: GitHubContributorsCoordinator())
        self.module = module
    }
    
    var body: some View {
        NavigationStack(path: $coordinator.navigationStack) {
            module.makeContributorsView()
                .environmentObject(coordinator)
                .navigationDestination(for: GitHubContributorsCoordinator.ContributorRoute.self) { route in
                    switch route {
                    case .detail(let contributor):
                        ContributorDetailView(contributor: contributor)
                            .environmentObject(coordinator)
                    }
                }
        }
    }
} 