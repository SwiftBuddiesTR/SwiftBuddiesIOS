//
//  File.swift
//  SwiftBuddiesMain
//
//  Created by dogukaan on 16.12.2024.
//  Copyright © 2024 SwiftBuddies. All rights reserved.
//

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

struct GitHubContributorsFlow: View {
    @StateObject private var coordinator: GitHubContributorsCoordinator
    private let module: GitHubContributorsModule
    
    init(module: GitHubContributorsModule) {
        self._coordinator = StateObject(wrappedValue: GitHubContributorsCoordinator())
        self.module = module
    }
    
    var body: some View {
        NavigationStack(path: $coordinator.navigationStack) {
            module.getContributorsView()
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
