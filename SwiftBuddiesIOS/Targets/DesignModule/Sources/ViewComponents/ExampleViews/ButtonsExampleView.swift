//
//  ButtonsExampleView.swift
//  Design
//
//  Created by dogukaan on 2.03.2025.
//

import SwiftUI

public struct ButtonsExampleView: View {
    @State private var isLoading = false
    @State private var isLiked = false
    @State private var isCommented = false
    
    // Button Configuration States
    @State private var selectedStyleIndex = 0
    @State private var selectedShape = BuddiesButtonStyle.Shape.roundedRectangle
    @State private var selectedSize = BuddiesButtonStyle.Size.large
    @State private var selectedWidth = BuddiesButtonStyle.WidthType.fill
    @State private var isDestructive = false
    @State private var showLeadingIcon = false
    @State private var selectedColor = Color.blue
    
    private let styleOptions = ["Primary", "Secondary", "Inverted", "Ghost", "Text"]
    private let colorOptions: [(name: String, color: Color)] = [
        (DesignAsset.Colors.white.name, DesignAsset.Colors.white.swiftUIColor),
        (DesignAsset.Colors.black.name, DesignAsset.Colors.black.swiftUIColor),
        (DesignAsset.Colors.fulvous.name, DesignAsset.Colors.fulvous.swiftUIColor),
        (DesignAsset.Colors.cyan.name, DesignAsset.Colors.cyan.swiftUIColor),
        (DesignAsset.Colors.olive.name, DesignAsset.Colors.olive.swiftUIColor),
        (DesignAsset.Colors.beaver.name, DesignAsset.Colors.beaver.swiftUIColor),
    ]
    
    private var currentStyle: BuddiesButtonStyle.Style {
        switch selectedStyleIndex {
        case 0:
            return .primary(color: selectedColor)
        case 1:
            return .secondary(color: selectedColor)
        case 2:
            return .inverted
        case 3:
            return .ghost
        case 4:
            return .text(labelColor: selectedColor)
        default:
            return .primary()
        }
    }
    
    private var currentRole: BuddiesButtonStyle.Role {
        isDestructive ? .destructive : .default
    }
    
    public init() {}
    
    public var body: some View {
        List {
            Section("Interactive Button Studio") {
                VStack(alignment: .center, spacing: 20) {
                    // Live Button Preview
                    Button("Example Button") {}
                        .buttonStyle(.styled(
                            style: currentStyle,
                            size: selectedSize,
                            width: selectedWidth,
                            role: currentRole,
                            shape: selectedShape,
                            leadingIcon: showLeadingIcon ? Image(systemName: "star") : nil,
                            isLoading: isLoading
                        ))
                        .padding(.vertical)
                    
                    // Toggle Loading State
                    HStack {
                        Text("Loading")
                        Spacer()
                        Toggle("", isOn: $isLoading)
                            .labelsHidden()
                    }
                    
                    // Toggle Destructive
                    HStack {
                        Text("Destructive")
                        Spacer()
                        Toggle("", isOn: $isDestructive)
                            .labelsHidden()
                    }
                    
                    // Toggle Leading Icon
                    HStack {
                        Text("Leading Icon")
                        Spacer()
                        Toggle("", isOn: $showLeadingIcon)
                            .labelsHidden()
                    }
                }
                .padding(.vertical, 8)
            }
            
            Section("Button Style") {
                Picker("Style", selection: $selectedStyleIndex) {
                    ForEach(0..<styleOptions.count, id: \.self) { index in
                        Text(styleOptions[index]).tag(index)
                    }
                }
                .pickerStyle(.segmented)
                
                ColorPicker("Custom Color", selection: $selectedColor)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(0..<colorOptions.count, id: \.self) { index in
                            Button {
                                selectedColor = colorOptions[index].1
                            } label: {
                                Circle()
                                    .fill(colorOptions[index].1)
                                    .frame(width: 32, height: 32)
                                    .overlay(
                                        Circle()
                                            .stroke(selectedColor == colorOptions[index].1 ? .primary : .clear, lineWidth: 2)
                                    )
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.vertical, 8)
                }
            }
            
            Section("Button Configuration") {
                Picker("Shape", selection: $selectedShape) {
                    Text("Rounded Rectangle").tag(BuddiesButtonStyle.Shape.roundedRectangle)
                    Text("Capsule").tag(BuddiesButtonStyle.Shape.capsule)
                }
                .pickerStyle(.segmented)
                
                Picker("Size", selection: $selectedSize) {
                    Text("Small").tag(BuddiesButtonStyle.Size.small)
                    Text("Medium").tag(BuddiesButtonStyle.Size.medium)
                    Text("Large").tag(BuddiesButtonStyle.Size.large)
                }
                .pickerStyle(.segmented)
                
                Picker("Width", selection: $selectedWidth) {
                    Text("Fill").tag(BuddiesButtonStyle.WidthType.fill)
                    Text("Hug").tag(BuddiesButtonStyle.WidthType.hug)
                }
                .pickerStyle(.segmented)
            }
            
            Section("Color Variations") {
                VStack(spacing: 16) {
                    ForEach(0..<colorOptions.count, id: \.self) { index in
                        Button(colorOptions[index].0) {}
                            .buttonStyle(.styled(
                                style: .primary(color: colorOptions[index].1),
                                width: .fill
                            ))
                    }
                }
                .padding(.vertical, 8)
            }
            
            Section("Social Action Buttons") {
                HStack(spacing: 16) {
                    SocialActionButton(
                        type: .like,
                        count: isLiked ? 42 : 41,
                        isSelected: $isLiked
                    )
                    
                    SocialActionButton(
                        type: .comment,
                        count: isCommented ? 13 : 12,
                        isSelected: $isCommented
                    )
                }
            }
        }
        .navigationTitle("Button Studio")
    }
}

#Preview {
    NavigationView {
        ButtonsExampleView()
    }
} 
