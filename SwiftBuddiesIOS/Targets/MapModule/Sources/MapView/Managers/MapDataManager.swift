//
//  MapDataManager.swift
//  SwiftBuddiesIOS
//
//  Created by Oğuzhan Abuhanoğlu on 17.11.2024.
//

import Foundation
import SwiftUI
import SwiftData

// LOCAL DATA MANAGER
@MainActor
class MapDataManager {
    var modelContext: ModelContext? // The optional model context value
    
    init() {
        
    }
    
    
    func getAllEvents() -> [EventModel] {
        guard let modelContext else { return [] }
        do {
            print("Loading all events from context...")
            let fetchDescriptor = FetchDescriptor<EventModel>()
            let events = try modelContext.fetch(fetchDescriptor)
            print("Loaded events count: \(events.count)")
            return events
        } catch {
            print("Error fethed data: \(error)")
            return []
        }
        
    }
    

    
    func addUniqueItems(
        events: [EventModel]
    ) {
        guard let modelContext else { return }

        let existingEvents = Set(getAllEvents().map { $0.id })
        debugPrint(existingEvents)
        for event in events {
            if !existingEvents.contains(event.id) {
                modelContext.insert(event)
                print("existing event name: \(event.name)")
                debugPrint("Added event: \(event.id)")
                print("local events count: \(events.count)")
            }
        }
    }
    
    
    func deleteAllEvents() {
        guard let modelContext else { return }

        do {
            print("Deleting all events from context...")
            let fetchDescriptor = FetchDescriptor<EventModel>()
            let events = try modelContext.fetch(fetchDescriptor)
            for event in events {
                modelContext.delete(event)
            }
            print("Deleted events count: \(events.count)")
        } catch {
            let errorMessage = "Error deletion data: \(error)"
            print(errorMessage)
        }
    }
}
