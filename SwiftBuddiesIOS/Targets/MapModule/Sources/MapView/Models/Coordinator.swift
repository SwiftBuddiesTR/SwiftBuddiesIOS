//
//  Coordinator.swift
//  Map
//
//  Created by Oğuzhan Abuhanoğlu on 11.07.2024.
//

import Foundation
import SwiftUI


class Coordinator: ObservableObject {
    
    enum NavigationDestination: Hashable {
        case mapView
        case newEventView
        case selectLocationMapView
    }

    @Published var path = NavigationPath()
    
    func navigate(to destination: NavigationDestination) {
        path.append(destination)
    }
    
    func popToRoot() {
        path.removeLast(path.count)
    }
}
