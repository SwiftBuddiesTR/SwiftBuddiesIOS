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
    var dataManager: MapDataManager = .init()
    
    
    @Published var allEvents: [EventModel] = []
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
    
    @Published var region : MKCoordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 40, longitude: 40), span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
    
    @Published private(set) var currentCoord: Coord = Coord(lat: 0, lon: 0)
    private var cancellables = Set<AnyCancellable>()
    
    @Published var categories: Categories
    
    var filteredCategories: Categories {
        categories.filter { $0.name != "All" }
    }
    
    init() {
        self.categories = .mock
        self.apiClient = .shared
        addSubscribers()
    }
    
    func addSubscribers() {
        locationManager.$lastKnownLocation
            .sink { [weak self] coord in
                self?.setMapRegion(to: coord)
            }
            .store(in: &cancellables)
    }
    
    
    func addItems(events: [EventModel]) {
        dataManager.addUniqueItems(events: events)
    }
    
    func updateAllEvents() async {
        await fetchEvents()
        allEvents = dataManager.getAllEvents()
    }
    
    func deleteAllEvents() {
        dataManager.deleteAllEvents()
    }
    
    
    private func fetchEvents() async {
        let request = MapGetEventsRequest()
        
        do {
            let data = try await apiClient.perform(request)
            debugPrint("Events Success: \(data.events?.count)")
            
            guard let mapEvents = data.events else {
                return
            }
            
            let events: [EventModel] = mapEvents.compactMap { mapEvent in
                guard
                    let uid = mapEvent.uid,
                    let categoryString = mapEvent.category,
                    let category = Categories.mock.first(where: { $0.name == categoryString }),
                    let name = mapEvent.name,
                    let description = mapEvent.description,
                    let startDate = mapEvent.startDate,
                    let dueDate = mapEvent.dueDate,
                    let latitude = mapEvent.latitude,
                    let longitude = mapEvent.longitude
                else {
                    return nil
                }
                
                return EventModel(
                    uid: uid,
                    category: category,
                    name: name,
                    aboutEvent: description,
                    startDate: startDate,
                    dueDate: dueDate,
                    latitude: latitude,
                    longitude: longitude
                )
            }
            dataManager.addUniqueItems(events: events)
        } catch {
            debugPrint(error)
        }
    }
    
    // MARK: DATA FILTERING AND MAP FUNCS
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
    
    
    func filterItems() {
        selectedItems.removeAll()
        if selectedCategory?.name == "All" {
            selectedItems = allEvents
        }
        
        for item in allEvents {
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
extension MapViewModel {
    // MARK: - RegisterRequest
    struct MapGetEventsRequest: Requestable {
        
        typealias Data = MapEventsResponseModel
        
        func toUrlRequest() throws -> URLRequest {
            try URLProvider.returnUrlRequest(
                method: .get,
                url: APIs.Map.getEvents.url(),
                data: self
            )
        }
    }
}
