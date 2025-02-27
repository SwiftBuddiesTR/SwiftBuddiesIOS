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
    private let mapService = MapService()
    private var locationManager = LocationManager.shared
   
    
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
    
    @Published var region: MKCoordinateRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 40, longitude: 40),
        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    )
    
    @Published var categories: Categories
    @Published var lastKnownLocation: Coord?
    
    var filteredCategories: Categories {
        categories.filter { $0.name != "All" }
    }
    
    init() {
        self.categories = .mock
        self.apiClient = .shared
        self.selectedCategory = self.categories.first
        
        // LocationManager'ı başlat ve güncellemeleri al
        locationManager.setLocationUpdateHandler { [weak self] coordinate in
            // Konum güncellendiğinde ViewModel'deki lastKnownLocation'u güncelle
            self?.lastKnownLocation = Coord(lat: coordinate.latitude.magnitude, lon: coordinate.longitude.magnitude)
            self?.setMapRegion(to: self?.lastKnownLocation)
        }
        
        self.locationManager.startUpdatingLocation()
        
        setUserLocation()
    }
    
    // MARK: DATA && FILTERING
    func getAllEvents() async {
        allEvents = await mapService.fetchEvents()
        DispatchQueue.main.async {
            self.selectedEvents = self.allEvents
        }
        
        print("all fetched events count: \(allEvents.count)")
        print("all fetched events: \(allEvents)")
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
    
    
    
    // MARK: Set map region, get user location
    func setUserLocation(errorCompletion: (() -> Void)? = nil) {
        if let location = lastKnownLocation {
            setMapRegion(to: location)
        } else {
            errorCompletion?()
        }
    }
    
    private func setMapRegion(to coord: Coord?) {
        guard let coord, currentEvent == nil else {
            return
        }
        let coordinate = CLLocationCoordinate2D(latitude: coord.lat, longitude: coord.lon)
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.05)
        self.region = MKCoordinateRegion(center: coordinate, span: span)
    }
    
    private func setMapRegion(to item: EventModel?) {
        guard let item else {
            return
        }
        let coordinate = CLLocationCoordinate2D(latitude: item.latitude, longitude: item.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        self.region = MKCoordinateRegion(center: coordinate, span: span)
    }
    
    
    func toggleEventList() {
        withAnimation(.easeInOut) {
            showEventListView.toggle()
        }
    }
    
    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }
    
    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }
}
