//
//  BuddiesButtonStyle.swift
//  Design
//
//  Created by dogukaan on 2.03.2025.
//

import SwiftUI

// Adding the necessary import for StrokedShape

public struct BuddiesButtonStyle: ButtonStyle {
    public enum Style {
        case text(labelColor: Color = DesignAsset.buddiesBlack.swiftUIColor)
        case primary(color: Color = DesignAsset.buddiesTeal.swiftUIColor)
        case secondary(color: Color = DesignAsset.buddiesPhotoBlue.swiftUIColor)
        case inverted
        case ghost
    }

    public enum Shape {
        case capsule
        case roundedRectangle
    }
    
    public enum Role {
        case `default`
        case destructive
    }

    public enum WidthType: String, CaseIterable, Identifiable, CustomStringConvertible {
        case fill
        case hug

        public var id: String { rawValue }
        public var description: String { rawValue.capitalized }

        var width: CGFloat? {
            switch self {
            case .fill:
                .infinity
            case .hug:
                nil
            }
        }
    }

    public enum Size {
        case small
        case medium
        case large
    }

    let style: Style
    let width: WidthType
    let shape: Shape
    let leadingIcon: Image?
    let isLoading: Bool?
    let size: Size
    let role: Role

    public init(
        style: Style,
        width: WidthType = .fill,
        size: Size = .large,
        shape: Shape = .roundedRectangle,
        role: Role = .default,
        leadingIcon: Image? = nil,
        isLoading: Bool? = nil
    ) {
        self.style = style
        self.width = width
        self.shape = shape
        self.size = size
        self.role = role
        self.leadingIcon = leadingIcon
        self.isLoading = isLoading
    }

    var fontSize: CGFloat {
        switch size {
        case .small:
            12
        case .medium:
            14
        case .large:
            16
        }
    }

    var labelColor: Color {
        switch style {
        case let .text(color): color
        case .primary(let color): color
        case .secondary(let color): color
        case .inverted: Color.blue
        case .ghost: Color.gray
        }
    }

    var backgroundColor: Color {
        switch role {
        case .default:
            switch style {
            case .text: Color.clear
            case .primary(let color): color
            case .secondary(let color): color.opacity(0.6)
            case .inverted: Color.gray.opacity(0.2)
            case .ghost: Color.clear
            }
        case .destructive:
            switch style {
            case .text: Color.clear
            case .primary: Color.red
            case .secondary: Color.red.opacity(0.2)
            case .inverted: Color.red.opacity(0.2)
            case .ghost: Color.clear
            }
        }
     
    }

    @Environment(\.isEnabled) var isEnabled: Bool
    
    var isDisabled: Bool {
        isLoading == true || !isEnabled
    }

    public func makeBody(configuration: Configuration) -> some View {
        buttonStyle(configuration: configuration)
            .disabled(isDisabled)
    }

    @ViewBuilder
    func buttonStyle(configuration: Configuration) -> some View {
        switch style {
        case .text:
            HStack(spacing: 8) {
                leadingIcon?
                    .resizable()
                    .renderingMode(.template)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20, height: 20)
                configuration.label
                    .foregroundStyle(labelColor)
                    .font(.system(size: fontSize, weight: .semibold))
            }
        default:
            HStack(spacing: 8) {
                leadingIcon?
                    .resizable()
                    .renderingMode(.template)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20, height: 20)
                configuration.label
                    .font(.system(size: fontSize, weight: .semibold))
            }
            .foregroundStyle(labelColor)
            .padding(.horizontal, 18)
            .padding(.vertical, 10)
            .frame(maxWidth: width.width)
            .opacity(isLoading == true ? 0 : 1)
            .overlay(
                Group {
                    if isLoading == true {
                        ProgressView()
                    }
                })
            .background(
                backgroundColor(configuration: configuration)
            )
        }
    }

    @ViewBuilder
    private func getShape(configuration: Configuration) -> some View {
        switch shape {
        case .capsule:
            Capsule()
        case .roundedRectangle:
            RoundedRectangle(cornerRadius: 12)
        }
    }
    
    private func strokedShape() -> StrokedShape.Shape {
        switch shape {
        case .capsule: .capsule
        case .roundedRectangle: .roundedRectangle(radius: 12)
        }
    }
    
    @ViewBuilder
    func backgroundColor(configuration: Configuration) -> some View {
        switch style {
        case .text: Color.clear
        case .ghost:
            getShape(configuration: configuration)
                .foregroundStyle(configuration.isPressed ? backgroundColor.opacity(0.7) : backgroundColor)
                .opacity(isDisabled ? 0.7 : 1)
                .overlay {
                    switch shape {
                    case .capsule:
                        Capsule()
                            .stroke(Color(red: 0.9, green: 0.92, blue: 0.96), lineWidth: 1)
                    case .roundedRectangle:
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color(red: 0.9, green: 0.92, blue: 0.96), lineWidth: 1)
                    }
                }
        default:
            getShape(configuration: configuration)
                .foregroundStyle(configuration.isPressed ? backgroundColor.opacity(0.7) : backgroundColor)
                .opacity(isDisabled ? 0.7 : 1)
        }
    }
}

// MARK: - Extension for easier usage
public extension ButtonStyle where Self == BuddiesButtonStyle {
    static func styled(
        style: BuddiesButtonStyle.Style,
        size: BuddiesButtonStyle.Size = .large,
        width: BuddiesButtonStyle.WidthType = .fill,
        role: BuddiesButtonStyle.Role = .default,
        shape: BuddiesButtonStyle.Shape = .roundedRectangle,
        leadingIcon: Image? = nil,
        isLoading: Bool? = false
    ) -> Self {
        BuddiesButtonStyle(
            style: style,
            width: width,
            size: size,
            shape: shape,
            role: role,
            leadingIcon: leadingIcon,
            isLoading: isLoading
        )
    }
} 


