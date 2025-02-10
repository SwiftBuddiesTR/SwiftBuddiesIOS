//
//  Notification+Extension.swift
//  SwiftBuddiesIOS
//
//  Created by dogukaan on 17.09.2024.
//

import Foundation

public extension Notification.Name {
    static let signOutNotification = Notification.Name("SignOutNotification")
}

public extension Notification.Name {
    static let didLoggedIn = Notification.Name("didLoggedIn")
    static let didLoggedOut = Notification.Name("didLoggedOut")
}

