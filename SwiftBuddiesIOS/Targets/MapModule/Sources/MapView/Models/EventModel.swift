//
//  Location.swift
//  Map
//
//  Created by Oğuzhan Abuhanoğlu on 12.05.2024.

import Foundation
import SwiftData

@Model
public class EventModel: Identifiable {
    public let id: String
    let category: Category
    let name: String
    let aboutEvent: String
    let startDate: String
    let dueDate: String
    let latitude: Double
    let longitude: Double
    
    
    init(
        category: Category,
        name: String,
        aboutEvent: String,
        startDate: String,
        dueDate: String,
        latitude: Double,
        longitude: Double
    ) {
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

typealias Categories = [Category]

public struct Category: Identifiable, Codable, Hashable {
    public let id: String
    let name: String
    let color: String
    
    init(name: String, color: String) {
        self.id = UUID().uuidString
        self.name = name
        self.color = color
    }
    
    init(id: String, name: String, color: String) {
        self.id = id
        self.name = name
        self.color = color
    }
}

extension Category {
    static let mock: Category = .init(
        name: "Meeting",
        color: "#FF0000"
    )
}

extension Categories {
    static let mock: Categories = [
        Category(name: "All", color: "#FFFFFF"),
        Category(name: "Meeting", color: "#FF0000"),
        Category(name: "Study Boddy", color: "#FFFF00"),
        Category(name: "Places to Work", color: "#00FF00"),
        Category(name: "SwiftBuddies Event", color: "#0000FF")
    ]
}
