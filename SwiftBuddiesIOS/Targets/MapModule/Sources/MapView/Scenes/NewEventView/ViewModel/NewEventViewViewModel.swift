//
//  NewEventViewViewModels.swift
//  Map
//
//  Created by Oğuzhan Abuhanoğlu on 19.07.2024.
//

import Foundation

class NewEventViewViewModel: ObservableObject {
    
    var categories: [String] {
        EventCategory.allCases.map { $0.rawValue }
    }
        
    var filteredCategories: [String] {
        categories.filter { $0 != "All" }
    }
    
    @Published var selectedCategory: EventCategory.RawValue?
    @Published var nameText: String = ""
    @Published var descriptionText: String = ""
    @Published var adressText: String = ""
    @Published var startDate: Date = Date()
    @Published var dueDate: Date = Date()
    
}
