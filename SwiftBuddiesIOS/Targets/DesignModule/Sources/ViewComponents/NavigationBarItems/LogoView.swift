//
//  File.swift
//  SwiftBuddiesIOS
//
//  Created by dogukaan on 2.03.2025.
//

import SwiftUI

// MARK: - UI Components
public struct LogoView: View {
    public init() {}
    public var body: some View {
        // If Design module is not available, you might need to adjust this
        Image("logo", bundle: DesignResources.bundle) // Replace with DesignResources.bundle when available
            .resizable()
            .scaledToFill()
            .frame(width: 100, height: 32)
    }
}
