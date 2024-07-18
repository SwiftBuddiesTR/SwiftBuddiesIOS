//
//  Location.swift
//  Map
//
//  Created by Oğuzhan Abuhanoğlu on 12.05.2024.
//

import Foundation
import SwiftData

@Model
public class EventModel: Identifiable{
    public let id: String
    let category: String
    let name: String
    let aboutEvent: String
    let startDate: Date
    let dueDate: Date
    let latitude: Double
    let longitude: Double
    
    
    init(category: String, name: String, aboutEvent: String, startDate: Date, dueDate: Date, latitude: Double, longitude: Double) {
        self.id = UUID().uuidString
        self.category = category
        self.name = name
        self.aboutEvent = aboutEvent
        self.startDate = startDate
        self.dueDate = dueDate
        self.latitude = latitude
        self.longitude = longitude
        
    }
}
