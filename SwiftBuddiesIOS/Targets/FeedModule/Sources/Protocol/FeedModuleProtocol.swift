//
//  File.swift
//  SwiftBuddiesIOS
//
//  Created by dogukaan on 19.12.2024.
//

import SwiftUI

public protocol FeedModuleProtocol {
    associatedtype FeedView: View
    
    var view: FeedView { get }
}
