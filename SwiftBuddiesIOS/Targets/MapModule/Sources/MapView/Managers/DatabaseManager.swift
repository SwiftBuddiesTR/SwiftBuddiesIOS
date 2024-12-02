//
//  DatabaseManager.swift
//  Map
//
//  Created by Oğuzhan Abuhanoğlu on 2.12.2024.
//

import Foundation
import BuddiesNetwork
import Network

class DatabaseManager {
    
    private let apiClient: BuddiesClient!
    
    init() {
        self.apiClient = .shared
    }
    
    func createEvent(event: NewEventModel) async {
        let request = MapCreateEventRequest(
            category: event.category.name,
            name: event.name,
            description: event.aboutEvent,
            startDate: event.startDate,
            dueDate: event.dueDate,
            latitude: event.latitude,
            longitude: event.longitude
        )
        
        do {
            let data = try await apiClient.perform(request)
            print("new event created \(data)")
            
        } catch {
            debugPrint(error)
        }
    }
    
    
    func fetchEvents() async -> [EventModel]{
        let request = MapGetEventsRequest()
        var fetchedEvents: [EventModel] = []
        
        do {
            let data = try await apiClient.perform(request)
            
            guard let mapEvents = data.events else {
                return []
            }
            
            let events: [EventModel] = mapEvents.compactMap { mapEvent in
                guard
                    let uid = mapEvent.uid,
                    let categoryString = mapEvent.category,
                    let category = Categories.mock.first(where: { $0.name == categoryString }),
                    let name = mapEvent.name,
                    let description = mapEvent.description,
                    let startDate = mapEvent.startDate,
                    let dueDate = mapEvent.dueDate,
                    let latitude = mapEvent.latitude,
                    let longitude = mapEvent.longitude
                else {
                    return nil
                }
                
                return EventModel(
                    uid: uid,
                    category: category,
                    name: name,
                    aboutEvent: description,
                    startDate: startDate,
                    dueDate: dueDate,
                    latitude: latitude,
                    longitude: longitude
                )
            }
            fetchedEvents = events
            print("fetched events count: that is the counts of events in the database\(fetchedEvents.count)")
            
            
        } catch {
            debugPrint(error)
        }
        
        return fetchedEvents
    }
}


struct MapCreateEventRequest: Requestable {
    
    let category: String?
    let name: String?
    let description: String?
    let startDate: String?
    let dueDate: String?
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
    
    struct Data: Decodable {
        var uid: String?
    }
    
    
    func toUrlRequest() throws -> URLRequest {
        try URLProvider.returnUrlRequest(
            method: .post,
            url: APIs.Map.createEvent.url(),
            data: self
        )
    }
}



struct MapGetEventsRequest: Requestable {
    
    typealias Data = MapEventsResponseModel
    
    func toUrlRequest() throws -> URLRequest {
        try URLProvider.returnUrlRequest(
            method: .get,
            url: APIs.Map.getEvents.url(),
            data: self
        )
    }
}

