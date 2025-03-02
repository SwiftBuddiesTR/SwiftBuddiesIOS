//
//  File.swift
//  SwiftBuddiesIOS
//
//  Created by dogukaan on 2.03.2025.
//

import SwiftUI

public protocol ProfileModuleProtocol {
    associatedtype ProfileViewType: View
    
    func getProfileView() -> ProfileViewType
}
