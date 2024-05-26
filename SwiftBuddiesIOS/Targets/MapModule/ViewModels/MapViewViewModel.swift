//
//  MapViewViewModel.swift
//  Map
//
//  Created by Oğuzhan Abuhanoğlu on 12.05.2024.
//

import Foundation
import SwiftUI
import MapKit

class MapViewViewModel: ObservableObject {
    
    //    @State private var selectedCategory: String? = nil
        /*@Published var locations: [Location] = [
            Location(name: "Boga Heykeli", coordinate: CLLocationCoordinate2D(latitude: 40.990467, longitude: 29.029162)),
            Location(name: "Coffee Shop 1", coordinate: CLLocationCoordinate2D(latitude: 41.043544, longitude: 29.004255)),
            Location(name: "Coffee Shop 1", coordinate: CLLocationCoordinate2D(latitude: 41.06, longitude: 29)),
        ]*/
   
        @Published var position: MapCameraPosition = .userLocation(fallback: .automatic)
        @Published var categoryModalShown = false
        @Published var selectedCategory: String = "Select Location"
        @Published var selectedDetent: PresentationDetent = .fraction(0.2)
        @Published var dismissableMessage: Bool = false
        
    
    init(){}
}
