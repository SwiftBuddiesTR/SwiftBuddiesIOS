//
//  NewEventViewViewModels.swift
//  Map
//
//  Created by Oğuzhan Abuhanoğlu on 19.07.2024.
//

import Foundation

class NewEventViewViewModel: ObservableObject {
    
    @Published var selection: String = "Select a category"
    @Published var nameText: String = ""
    @Published var descriptionText: String = ""
    @Published var adressText: String = ""
    @Published var startDate: Date = Date()
    @Published var dueDate: Date = Date()
    
}
