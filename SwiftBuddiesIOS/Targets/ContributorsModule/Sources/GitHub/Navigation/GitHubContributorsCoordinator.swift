import SwiftUI

@MainActor
final class GitHubContributorsCoordinator: ObservableObject {
    enum ContributorRoute: Hashable {
        case detail(Contributor)
    }
    
    @Published var navigationStack: [ContributorRoute] = []
    
    func push(_ route: ContributorRoute) {
        navigationStack.append(route)
    }
    
    func popToRoot() {
        navigationStack.removeAll()
    }
} 
