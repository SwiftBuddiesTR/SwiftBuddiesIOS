//
//  Color.swift
//  Buddies
//
//  Created by Fatih Özen on 12.02.2025.
//

import SwiftUI

extension Color {
    static var dynamicColor: Color {
        Color(UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark ? .white : .black
        })
    }
    
    static var dynamicBackgroundColor: Color {
        Color(UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark ? .black : .white
        })
    }
}
