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
import Combine
import BuddiesNetwork
import Network
import SwiftData

@MainActor
class MapViewModel: ObservableObject {
    
    private let apiClient: BuddiesClient
    private var locationManager = LocationManager()
    private let mapService = MapService()
    
    @Published var allEvents: [EventModel] = []
    @Published var selectedEvents: [EventModel] = []

    @Published var currentEvent: EventModel? {
        didSet {
            withAnimation(.easeInOut) {
                setMapRegion(to: currentEvent)
            }
        }
    }
    
    @Published var categoryModalShown: Bool = false
    @Published var selectedCategory: Category?
    @Published var selectedDetent: PresentationDetent = .fraction(0.9)
    @Published var showEventListView: Bool = false
    @Published var showExplanationText: Bool = true
    @Published var showAlert: Bool = false

    
    @Published var region : MKCoordinateRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 40, longitude: 40),
        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    )
    
    @Published var categories: Categories
    
    var filteredCategories: Categories {
        categories.filter { $0.name != "All" }
    }
    
    init() {
        self.categories = .mock
        self.apiClient = .shared
        self.selectedCategory = self.categories.first
        setUserLocation()
    }
    
    func setUserLocation(errorCompletion: (() -> Void)? = nil) {
        if let location = locationManager.lastKnownLocation {
            setMapRegion(to: location)
        } else {
            errorCompletion?()
        }
    }
    
    func getAllEvents() async {
        allEvents = await mapService.fetchEvents()
        selectedEvents = allEvents
    }
    
    
    // MARK: DATA FILTERING
    private func setMapRegion(to item: EventModel?) {
        guard let item else {
            return
        }
        let coordinate = CLLocationCoordinate2D(latitude: item.latitude, longitude: item.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        self.region = MKCoordinateRegion(center: coordinate, span: span)
    }
    
    
    private func setMapRegion(to coord: Coord?) {
        guard let coord, currentEvent == nil else {
            return
        }
        let coordinate = CLLocationCoordinate2D(latitude: coord.lat, longitude: coord.lon)
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.05)
        self.region = MKCoordinateRegion(center: coordinate, span: span)
    }
    
    
    func filteredItems(items: [EventModel], selectedItems: inout [EventModel]) {
        selectedItems.removeAll()
        if selectedCategory?.name == "All" {
            selectedItems = items
        }
        
        for item in items {
            if selectedCategory?.name == item.category.name {
                selectedItems.append(item)
            }
        }
        
        if let firstItem = selectedItems.first {
            setMapRegion(to: firstItem)
        }
    }
    
    func toggleEventList() {
        withAnimation(.easeInOut) {
            showEventListView.toggle()
        }
    }
    
    
    // MARK: LOCATİON
    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }
    
    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }
}
