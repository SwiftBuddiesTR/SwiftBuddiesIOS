//
//  Location.swift
//  Map
//
//  Created by Oğuzhan Abuhanoğlu on 12.05.2024.
//

import Foundation
import SwiftUI
import MapKit


// Define a simple model for event
struct Location: Identifiable {
    let id = UUID()
    let category: String
    let name: String
    let aboutEvent: String
    let startDate: TimeInterval
    let dueDate: TimeInterval
    let coordinate: CLLocationCoordinate2D
    //let image: Image? = nil
    //let backgroundColor: Color? = nil
}
