//
//  File.swift
//  SwiftBuddiesIOS
//
//  Created by dogukaan on 19.12.2024.
//

import SwiftUI

public protocol FeedModuleProtocol {
    associatedtype FeedViewType: View
    
    func getFeedView() -> FeedViewType
}
