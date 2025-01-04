//
//  File.swift
//  SwiftBuddiesIOS
//
//  Created by dogukaan on 19.12.2024.
//

import SwiftUI

public struct FeedView: View {
    private let module: BuddiesFeedModule
    
    public init() {
        self.module = BuddiesFeedModule()
    }
    
    public var body: some View {
        FeedFlow(module: module)
    }
}

#Preview {
    FeedView()
}
