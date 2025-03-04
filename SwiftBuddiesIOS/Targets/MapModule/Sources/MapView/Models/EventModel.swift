//
//  Location.swift
//  Map
//
//  Created by Oğuzhan Abuhanoğlu on 12.05.2024.

import Foundation
import SwiftData

@Model
public class EventModel: Identifiable {
    public var id: String
    var category: Category
    var name: String
    var aboutEvent: String
    var startDate: String
    var dueDate: String
    var latitude: Double
    var longitude: Double

    
    init(
        uid: String,
        category: Category,
        name: String,
        aboutEvent: String,
        startDate: String,
        dueDate: String,
        latitude: Double,
        longitude: Double
    ) {
        self.id = uid
        self.category = category
        self.name = name
        self.aboutEvent = aboutEvent
        self.startDate = startDate
        self.dueDate = dueDate
        self.latitude = latitude
        self.longitude = longitude
    }
}

struct NewEventModel: Hashable, Codable {
    var category: Category
    var name: String
    var description: String
    var startDate: String
    var dueDate: String
    var latitude: Double?
    var longitude: Double?
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

// For previews
extension Category {
    static let mock: Category = Categories.mock[1]
}

extension Categories {
    static let mock: Categories = [
        Category(name: "All", color: "#FFFFFF"),
        Category(name: "Meeting", color: "#FF0000"),
        Category(name: "Study Buddy", color: "#FF8C00"),
        Category(name: "Places to Work", color: "#006400"),
        Category(name: "SwiftBuddies Event", color: "#0000FF")
    ]
}
