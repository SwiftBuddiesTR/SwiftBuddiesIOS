//
//  File.swift
//  SwiftBuddiesIOS
//
//  Created by dogukaan on 19.12.2024.
//

import SwiftUI

@MainActor
final class BuddiesFeedCoordinator: ObservableObject {
    
    enum BuddiesFeedRoute: Hashable {
        case addPost
        case postDetail(FeedPost)
        case userProfile(FeedUser)
    }
    
    @Published var navigationStack: [BuddiesFeedRoute] = []
    
    func push(_ route: BuddiesFeedRoute) {
        navigationStack.append(route)
    }
    
    func popToRoot() {
        navigationStack.removeAll()
    }
}

public struct FeedFlow: View {
    @StateObject private var coordinator = BuddiesFeedCoordinator()
    
    public init() {}
    
    public var body: some View {
        NavigationStack(path: $coordinator.navigationStack) {
            BuddiesFeedView(coordinator: coordinator)
                .navigationDestination(for: BuddiesFeedCoordinator.BuddiesFeedRoute.self) { route in
                    switch route {
                    case .addPost:
                        Text("Add Post View")
                    case .postDetail(let post):
                        Text("Post Detail View: \(post.content ?? "")")
                    case .userProfile(let user):
                        Text("User Profile: \(user.name)")
                    }
                }
        }
        .environmentObject(coordinator)
    }
}

#Preview {
    FeedFlow()
} 
