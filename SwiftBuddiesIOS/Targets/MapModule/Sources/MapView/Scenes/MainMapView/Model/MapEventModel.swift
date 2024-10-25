//
//  MapEventModel.swift
//  Map
//
//  Created by Oğuzhan Abuhanoğlu on 22.10.2024.
//

import Foundation

struct MapEventsResponseModel: Codable {
    let count: Int?
    let events: [MapEventModel]?
}

// MARK: - Event
struct MapEventModel: Codable {
    let id: String?
    let uid: String?
    let ownerUid: String?
    let category: String?
    let name: String?
    let description: String?
    let startDate: String?
    let dueDate: String?
    let latitude: Double?
    let longitude: Double?
    let v: Int?
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case uid = "uid"
        case ownerUid = "owner_uid"
        case category = "category"
        case name = "name"
        case description = "description"
        case startDate = "startDate"
        case dueDate = "dueDate"
        case latitude = "latitude"
        case longitude = "longitude"
        case v = "__v"
    }
}

// MARK: - Welcome
struct MapCreateEventRequestModel: Codable {
    let category: String?
    let name: String?
    let description: String?
    let startDate: Date?
    let dueDate: Date?
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
}
