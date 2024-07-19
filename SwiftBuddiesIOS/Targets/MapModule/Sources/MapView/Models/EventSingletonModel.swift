//
//  EventSingletonModel.swift
//  Map
//
//  Created by Oğuzhan Abuhanoğlu on 10.07.2024.
//

import Foundation

class EventSingletonModel {
    
    static var sharedInstance = EventSingletonModel()
    
    var category: String = EventCategory.RawValue()
    var name: String = ""
    var aboutEvent: String = ""
    var startDate: Date = Date()
    var dueDate: Date = Date()
    
    private init(){}
    
}
