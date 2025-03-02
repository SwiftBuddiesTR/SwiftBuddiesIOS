//
//  File.swift
//  SwiftBuddiesIOS
//
//  Created by dogukaan on 2.03.2025.
//

import SwiftUI
import Design

@MainActor
final class BuddiesProfileCoordinator: ObservableObject {
    enum BuddiesProfileRoute: Hashable {
        case editProfile
        case about
        case settings
        case buttonsShowcase
        case followers
        case following
    }
    
    @Published var navigationStack: [BuddiesProfileRoute] = []
    
    func push(_ route: BuddiesProfileRoute) {
        navigationStack.append(route)
    }
    
    func popToRoot() {
        navigationStack.removeAll()
    }
    
    func pop() {
        navigationStack.removeLast()
    }
}

public struct ProfileFlow: View {
    @StateObject private var coordinator: BuddiesProfileCoordinator
    private let module: BuddiesProfileModule
    
    init(module: BuddiesProfileModule) {
        self._coordinator = StateObject(wrappedValue: BuddiesProfileCoordinator())
        self.module = module
    }
    
    public var body: some View {
        NavigationStack(path: $coordinator.navigationStack) {
            module.getProfileView()
                .environmentObject(coordinator)
                .navigationDestination(for: BuddiesProfileCoordinator.BuddiesProfileRoute.self) { route in
                    switch route {
                    case .editProfile:
                        EditProfile()
                            .environmentObject(coordinator)
                    case .about:
                        AboutView()
                            .environmentObject(coordinator)
                    case .settings:
                        SettingsView()
                            .environmentObject(coordinator)
                    case .buttonsShowcase:
                        ButtonsExampleView()
                    case .followers:
                        Text("Followers View")
                            .environmentObject(coordinator)
                    case .following:
                        Text("Following View")
                            .environmentObject(coordinator)
                    }
                }
        }
    }
}
