//
//  DateExtension.swift
//  SwiftBuddiesIOS
//
//  Created by Oğuzhan Abuhanoğlu on 1.08.2024.
//

import Foundation

extension Date {
    
    func toISOString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.calendar = Calendar(identifier: .gregorian)
        return formatter.string(from: self)
    }
    
}
