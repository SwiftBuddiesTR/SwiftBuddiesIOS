//
//  NewEventViewViewModel.swift
//  Map
//
//  Created by Oğuzhan Abuhanoğlu on 18.07.2024.
//

import Foundation
import SwiftData

class LocationSelectionViewViewModel: ObservableObject {
    
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
