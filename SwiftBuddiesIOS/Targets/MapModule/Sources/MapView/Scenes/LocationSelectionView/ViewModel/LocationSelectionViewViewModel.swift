//
//  NewEventViewViewModel.swift
//  Map
//
//  Created by Oğuzhan Abuhanoğlu on 18.07.2024.
//

import Foundation
import SwiftData
import MapKit
import BuddiesNetwork
import Network

class LocationSelectionViewViewModel: ObservableObject {
    
    @Published var selectedAnnotation: MKPointAnnotation?
    @Published var searchText = ""
    @Published var searchResults: [MKMapItem] = []
    @Published var mapRegion: MKCoordinateRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 0, longitude: 0),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    private let apiClient: BuddiesClient!
    
    init() {
        self.apiClient = .shared
    }
    
    func search() {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchText
        
        let search = MKLocalSearch(request: request)
        search.start { response, error in
            if let response = response {
                self.searchResults = response.mapItems
            }
        }
    }
    
    func createEvent(event: NewEventModel) async {
        let request = MapCreateEventRequest(
            category: event.category.name,
            name: event.name,
            description: event.aboutEvent,
            startDate: event.startDate,
            dueDate: event.dueDate,
            latitude: event.latitude,
            longitude: event.longitude
        )
        
        do {
            let data = try await apiClient.perform(request)
            print("new event created \(data)")
            
        } catch {
            debugPrint(error)
        }
    }
}

struct NewEventModel: Hashable, Codable {
    var category: Category
    var name: String
    var aboutEvent: String
    var startDate: String
    var dueDate: String
    var latitude: Double?
    var longitude: Double?
}

struct MapCreateEventRequest: Requestable {
    
    let category: String?
    let name: String?
    let description: String?
    let startDate: String?
    let dueDate: String?
    let latitude: Double?
    let longitude: Double?

    enum CodingKeys: String, CodingKey {
        case category = "category"
        case name = "name"
        case description = "description"
        case startDate = "startDate"
        case dueDate = "dueDate"
        case latitude = "latitude"
        case longitude = "longitude"
    }
    
    struct Data: Decodable {
        var uid: String?
    }
    
    
    func toUrlRequest() throws -> URLRequest {
        try URLProvider.returnUrlRequest(
            method: .post,
            url: APIs.Map.createEvent.url(),
            data: self
        )
    }
}
