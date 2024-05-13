//
//  NewEventViewModel.swift
//  Map
//
//  Created by Oğuzhan Abuhanoğlu on 13.05.2024.
//

import Foundation

import Foundation

class NewEventViewModel: ObservableObject {
    
    @Published var name = ""
    @Published var category = ""
    @Published var about = ""
    @Published var startDate = Date()
    @Published var dueDate = Date()
    
    init(){}
    
    func createButtonClicked(){
        
    }
}
