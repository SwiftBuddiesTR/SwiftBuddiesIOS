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
    
    private let databaseManager = DatabaseManager()
    
    @Published var selectedAnnotation: MKPointAnnotation?
    @Published var searchText = ""
    @Published var searchResults: [MKMapItem] = []
    @Published var mapRegion: MKCoordinateRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 0, longitude: 0),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    
   
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
        await databaseManager.createEvent(event: event)
    }
    

}


