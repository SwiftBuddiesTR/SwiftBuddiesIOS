//
//  LoginButtonViewModifier.swift
//  Design
//
//  Created by Berkay Tuncel on 19.04.2024.
//

import SwiftUI

struct LoginButtonViewModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.title2)
            .fontWeight(.medium)
            .foregroundColor(.white)
            .frame(height: 55)
            .frame(maxWidth: .infinity)
            .background(DesignAsset.loginStrokeColor.swiftUIColor)
    }
}
