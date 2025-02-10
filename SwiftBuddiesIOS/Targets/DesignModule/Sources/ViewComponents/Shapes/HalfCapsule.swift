//
//  HalfCapsule.swift
//  Design
//
//  Created by Halit Baskurt on 16.04.2024.
//

import SwiftUI

public struct HalfCapsule: Shape {
    public init() { }
    
    public func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: .init(x: rect.minX, y: rect.minY))
            path.addLine(to: .init(x: rect.maxX, y: rect.minY))
            path.addLine(to: .init(x: rect.maxX, y: rect.midY))
            path.addArc(center: .init(x: rect.midX, y: rect.midY),
                        radius: rect.height/2,
                        startAngle: .degrees(0),
                        endAngle: .degrees(180),
                        clockwise: false)
            path.addLine(to: .init(x: rect.minX, y: rect.midY))
        }
    }
}
