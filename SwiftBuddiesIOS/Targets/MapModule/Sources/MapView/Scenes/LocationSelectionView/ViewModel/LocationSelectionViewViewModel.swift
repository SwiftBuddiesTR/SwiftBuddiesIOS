//
//  NewEventViewViewModel.swift
//  Map
//
//  Created by Oğuzhan Abuhanoğlu on 18.07.2024.
//

import Foundation
import SwiftData
import MapKit

class LocationSelectionViewViewModel: ObservableObject {
    
    @Published var selectedAnnotation: MKPointAnnotation?
    @Published var searchText = ""
    @Published var searchResults: [MKMapItem] = []
    @Published var mapRegion: MKCoordinateRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 0, longitude: 0),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    
    func addItem(
        modelContext: ModelContext,
        newEventModel: NewEventModel
    ) {
        guard let latitude = newEventModel.latitude,
              let longitude = newEventModel.longitude else { return }
        let event = EventModel(
            category: newEventModel.category,
            name: newEventModel.name,
            aboutEvent: newEventModel.aboutEvent,
            startDate: newEventModel.startDate,
            dueDate: newEventModel.dueDate,
            latitude: latitude,
            longitude: longitude
        )
        modelContext.insert(event)
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
