//
//  Location.swift
//  Map
//
//  Created by Oğuzhan Abuhanoğlu on 12.05.2024.
//

import Foundation
import MapKit
import SwiftData

@Model
class EventModel: Identifiable {
    let id: String
    let category: String
    let name: String
    let aboutEvent: String
    let startDate: TimeInterval
    let dueDate: TimeInterval
    let coordinate: CLLocationCoordinate2D
    
    init(category: String, name: String, aboutEvent: String, startDate: TimeInterval, dueDate: TimeInterval, coordinate: CLLocationCoordinate2D) {
        self.id = UUID().uuidString
        self.category = category
        self.name = name
        self.aboutEvent = aboutEvent
        self.startDate = startDate
        self.dueDate = dueDate
        self.coordinate = coordinate
    }
}
