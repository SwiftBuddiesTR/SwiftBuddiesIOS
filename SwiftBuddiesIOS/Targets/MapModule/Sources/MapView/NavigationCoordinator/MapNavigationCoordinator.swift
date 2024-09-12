//
//  Coordinator.swift
//  Map
//
//  Created by Oğuzhan Abuhanoğlu on 11.07.2024.
//

import Foundation
import SwiftUI


class MapNavigationCoordinator: ObservableObject {
    
    enum NavigationDestination: Hashable {
        case mapView
        case newEventView
        case selectLocationMapView(NewEventModel)
    }

    @Published var mapNavigationStack: [NavigationDestination] = []
    
    func navigate(to destination: NavigationDestination) {
        mapNavigationStack.append(destination)
    }
    
    func popToRoot() {
        mapNavigationStack.removeLast(mapNavigationStack.count)
    }
}
