//
//  File.swift
//  SwiftBuddiesIOS
//
//  Created by dogukaan on 2.03.2025.
//

import SwiftUI

public struct StrokedShape: ViewModifier {
    public enum Shape {
        case roundedRectangle(radius: CGFloat = 12)
        case capsule
    }
    
    let color: Color
    let shape: Shape
    let fillColor: Color
    
    public func body(content: Content) -> some View {
        content
            .background {
                switch shape {
                case let .roundedRectangle(radius):
                    RoundedRectangle(cornerRadius: radius)
                        .fill(fillColor)
                case .capsule:
                    Capsule()
                        .fill(fillColor)
                }
            }
            .overlay {
                switch shape {
                case let .roundedRectangle(radius):
                    RoundedRectangle(cornerRadius: radius)
                        .stroke(color, lineWidth: 1)
                case .capsule:
                    Capsule()
                        .stroke(color, lineWidth: 1)
                }
            }
    }
}

public extension View {
    func strokedBorder(
        shape: StrokedShape.Shape = .roundedRectangle(radius: 12),
        fillColor: Color = Color.clear,
        borderColor: Color = Color(red: 0.9, green: 0.92, blue: 0.96)
    ) -> some View {
        modifier(StrokedShape(color: borderColor, shape: shape, fillColor: fillColor))
    }
}
