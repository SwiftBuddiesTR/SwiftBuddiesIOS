//
//  MapViewViewModel.swift
//  Map
//
//  Created by Oğuzhan Abuhanoğlu on 12.05.2024.
//

import Foundation
import SwiftUI
import CoreData
import MapKit

class MapViewViewModel: ObservableObject {
    
    let container: NSPersistentContainer
    @Published var savedEvents: [EventEntity] = []
    
    @Published var position: MapCameraPosition = .userLocation(fallback: .automatic)
    @Published var categoryModalShown = false
    @Published var selectedCategory: String = "Select Location"
    @Published var selectedDetent: PresentationDetent = .fraction(0.2)
    @Published var dismissableMessage: Bool = false
    

    init(){
        container = NSPersistentContainer(name: "EventContainer")
        container.loadPersistentStores { description, error in
            if error != nil {
                print("ERROR when creating Container!")
            } else {
                print("Container created SUCCESFULLY")
            }
        }
    }
    
    func fetchData() {
        let request = NSFetchRequest<EventEntity>(entityName: "EventEntity")
        do {
            savedEvents = try container.viewContext.fetch(request)
        } catch let error {
            print("Error fetching: \(error)")
        }
    }
    
    func addData(category: String, name: String, description: String, adress: String, startDate: Date, dueDate: Date) {
        let newEvent = EventEntity(context: container.viewContext)
        newEvent.category = category
        newEvent.name = name
        newEvent.about = description
        newEvent.adress = adress
        newEvent.startDate = startDate
        newEvent.dueDate = dueDate
        saveData()
         
    }
    
    func saveData() {
        do {
            try container.viewContext.save()
            // to keep data updated
            fetchData()
        } catch let error {
            print("Error saving: \(error)")
        }
    }
    
    
    
}










//    @State private var selectedCategory: String? = nil
    /*@Published var locations: [Location] = [
        Location(name: "Boga Heykeli", coordinate: CLLocationCoordinate2D(latitude: 40.990467, longitude: 29.029162)),
        Location(name: "Coffee Shop 1", coordinate: CLLocationCoordinate2D(latitude: 41.043544, longitude: 29.004255)),
        Location(name: "Coffee Shop 1", coordinate: CLLocationCoordinate2D(latitude: 41.06, longitude: 29)),
    ]*/


 
