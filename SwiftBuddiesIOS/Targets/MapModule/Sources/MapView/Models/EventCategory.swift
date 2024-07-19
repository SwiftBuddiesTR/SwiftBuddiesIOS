//
//  EventCategory.swift
//  Map
//
//  Created by Oğuzhan Abuhanoğlu on 17.07.2024.
//

import Foundation

enum EventCategory: String, CaseIterable, Codable{
    case all = "All"
    case meeting = "Meeting"
    case studyBody = "Study Body"
    case placeToWork = "Place to work"
    case swiftBuddiesEvent = "Swift Buddies Event"
}
