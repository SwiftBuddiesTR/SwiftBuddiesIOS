import SwiftUI

@MainActor
final class GitHubContributorsCoordinator: ObservableObject {
    enum ContributorRoute: Hashable {
        case detail(Contributor)
        
        func hash(into hasher: inout Hasher) {
            switch self {
            case .detail(let contributor):
                hasher.combine(contributor.id)
            }
        }
        
        static func == (lhs: ContributorRoute, rhs: ContributorRoute) -> Bool {
            switch (lhs, rhs) {
            case (.detail(let lhsContributor), .detail(let rhsContributor)):
                return lhsContributor.id == rhsContributor.id
            }
        }
    }
    
    @Published var navigationStack: [ContributorRoute] = []
    
    func push(_ route: ContributorRoute) {
        navigationStack.append(route)
    }
    
    func popToRoot() {
        navigationStack.removeAll()
    }
} 