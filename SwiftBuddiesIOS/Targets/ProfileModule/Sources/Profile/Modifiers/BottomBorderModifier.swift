//
//  BottomBorderModifier.swift
//  Buddies
//
//  Created by Fatih Özen on 13.01.2025.
//

import SwiftUI

struct BottomBorderModifier: ViewModifier {
    var color: Color = .gray
    var height: CGFloat = 1
    
    func body(content: Content) -> some View {
        content
            .padding(.bottom, 6)
            .overlay(
                Rectangle()
                    .frame(height: height)
                    .foregroundColor(color),
                alignment: .bottom
            )
    }
}
