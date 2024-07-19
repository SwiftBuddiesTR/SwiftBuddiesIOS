//
//  MapViewViewModel.swift
//  Map
//
//  Created by Oğuzhan Abuhanoğlu on 12.05.2024.
//

import Foundation
import SwiftUI
import SwiftData
import MapKit
import CoreLocation

class MapViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    @Published var categoryModalShown = false
    @Published var selectedCategory: String = ""
    @Published var selectedDetent: PresentationDetent = .fraction(0.9)
    
    var categories: [String] {
        EventCategory.allCases.map { $0.rawValue }
    }
        
    var filteredCategories: [String] {
        categories.filter { $0 != "All" }
    }
   
    
    @Published var region: MKCoordinateRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    
    @Published var currentEvent: EventModel?
    
    let locationManager = CLLocationManager()
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            withAnimation {
                region = MKCoordinateRegion(
                    center: location.coordinate,
                    span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                )
            }
            locationManager.stopUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get user location: \(error)")
    }
    
    
    func setMapRegion(to item: EventModel) {
        let coordinate = CLLocationCoordinate2D(latitude: item.latitude, longitude: item.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        self.region = MKCoordinateRegion(center: coordinate, span: span)
        self.currentEvent = item
    }
    
    func filteredItems(items: [EventModel], selectedItems: inout [EventModel]) {
        selectedItems.removeAll()
        if selectedCategory == EventCategory.all.rawValue {
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
                print("1")
            }
        }
    }
    
    
}
