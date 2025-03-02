//
//  ContributorsModuleProtocol.swift
//  SwiftBuddiesMain
//
//  Created by dogukaan on 16.12.2024.
//  Copyright © 2024 SwiftBuddies. All rights reserved.
//

import SwiftUI

public protocol ContributorsModuleProtocol {
    associatedtype ContributorsViewType: View
    
    func getContributorsView() -> ContributorsViewType
} 
