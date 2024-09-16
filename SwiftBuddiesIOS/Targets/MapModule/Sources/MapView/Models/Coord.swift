//
//  Coord.swift
//  Map
//
//  Created by Oğuzhan Abuhanoğlu on 16.09.2024.
//

import Foundation

struct Coord: Codable, Equatable {
    let lat, lon: Double
    
    static func == (lhs: Coord, rhs: Coord) -> Bool { lhs.lat == rhs.lat && lhs.lon == rhs.lon }
}
