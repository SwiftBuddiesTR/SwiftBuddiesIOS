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
    
    @Published var position: MapCameraPosition = .userLocation(fallback: .automatic)
    @Published var categoryModalShown = false
    @Published var selectedCategory: String = "Select Location"
    @Published var selectedDetent: PresentationDetent = .fraction(0.9)
    @Published var dismissableMessage: Bool = false
    
    @Published var region: MKCoordinateRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    
    private let locationManager = CLLocationManager()
    
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
    
    func addItem(modelContext: ModelContext, id: String, category: String, name: String, about: String, startDate: Date, dueDate: Date, latitude: Double, longitude: Double) {
        let event = EventModel(category: category, name: name, aboutEvent: about, startDate: startDate, dueDate: dueDate, latitude: latitude, longitude: longitude)
        modelContext.insert(event)
    }
    
    func setMapRegion(to item: EventModel) {
        let coordinate = CLLocationCoordinate2D(latitude: item.latitude, longitude: item.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        withAnimation(.easeInOut) {
            self.region = MKCoordinateRegion(center: coordinate, span: span)
        }
    }
}
