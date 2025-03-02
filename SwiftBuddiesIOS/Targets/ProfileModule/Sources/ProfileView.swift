//
//  ProfileView.swift
//  SwiftBuddiesIOS
//
//  Created by dogukaan on 2.03.2025.
//

import SwiftUI

public struct ProfileView: View {
    private let module: BuddiesProfileModule
    
    public init() {
        self.module = BuddiesProfileModule()
    }
    
    public var body: some View {
        ProfileFlow(module: module)
    }
}

#Preview {
    ProfileView()
}
