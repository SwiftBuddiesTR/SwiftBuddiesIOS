//
//  MapViewViewModel.swift
//  Map
//
//  Created by Oğuzhan Abuhanoğlu on 12.05.2024.
//

import Foundation
import SwiftUI
import MapKit
import CoreLocation

class MapViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    @Published var selectedItems: [EventModel] = []
    @Published var currentEvent: EventModel?
    
    @Published var categoryModalShown: Bool = false
    @Published var selectedCategory: String = ""
    @Published var selectedDetent: PresentationDetent = .fraction(0.9)
    @Published var showEventListView: Bool = false

    var locationManager = LocationManager()
    
    @Published var showExplanationText: Bool = true
    
    // bunu backednden alacağız.
    @Published var categories: [String] = [
        "All", "Meeting", "Study Body", "Place to work", "Swift Buddies Event"
    ]
    
    var filteredCategories: [String] {
        categories.filter { $0 != "All" }
    }
    
    override init() {
        super.init()
        
        
    }
    
    func setMapRegion(to item: EventModel) {
        let coordinate = CLLocationCoordinate2D(latitude: item.latitude, longitude: item.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        locationManager.region = MKCoordinateRegion(center: coordinate, span: span)
        self.currentEvent = item
    }
    
    func filteredItems(items: [EventModel], selectedItems: inout [EventModel]) {
        selectedItems.removeAll()
        if selectedCategory == "All" /*EventCategory.all.rawValue*/ {
            selectedItems = items
        }
        
        for item in items {
            if selectedCategory == item.category {
                selectedItems.append(item)
            }
        }
        for item in selectedItems {
            if let firstItem = selectedItems.first {
                setMapRegion(to: firstItem)
            }
        }
    }
    
    func toggleEventList() {
        withAnimation(.easeInOut) {
            showEventListView.toggle()
        }
    }
    
    
}
