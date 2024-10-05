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

class MapViewModel: ObservableObject {
    
    @Published var selectedItems: [EventModel] = []
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
    
    private var locationManager = LocationManager()
    
    @Published var region : MKCoordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 40, longitude: 40), span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
//    @Published var region: MapCameraPosition = MapCameraPosition.region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 40, longitude: 40), span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)))
    @Published private(set) var currentCoord: Coord = Coord(lat: 0, lon: 0)
    private var cancellables = Set<AnyCancellable>()
    
    // bunu backednden alacağız.
    @Published var categories: Categories
    
    var filteredCategories: Categories {
        categories.filter { $0.name != "All" }
    }
    
    init() {
        self.categories = .mock
//        self.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: currentCoord.lat, longitude: currentCoord.lon ), span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
        addSubscribers()
    }
    
    func addSubscribers() {
        locationManager.$lastKnownLocation
            .sink { [weak self] coord in
                self?.setMapRegion(to: coord)
            }
            .store(in: &cancellables)
    }
    
    private func setMapRegion(to item: EventModel?) {
        guard let item else {
            return
        }
        let coordinate = CLLocationCoordinate2D(latitude: item.latitude, longitude: item.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        self.region = MKCoordinateRegion(center: coordinate, span: span)
//        self.region = MapCameraPosition.region(MKCoordinateRegion(center: coordinate, span: span))
    }
    
    private func setMapRegion(to coord: Coord?) {
        guard let coord, currentEvent == nil else {
            return
        }
        let coordinate = CLLocationCoordinate2D(latitude: coord.lat, longitude: coord.lon)
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.05)
        self.region = MKCoordinateRegion(center: coordinate, span: span)
//        self.region = MapCameraPosition.region(MKCoordinateRegion(center: coordinate, span: span))
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
    
    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }
    
    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }
    
    
}
