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
    
    public init() {}
    
    public var body: some View {
        List {
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
            
            Section("Button Styles") {
                Button("Primary Button") {}
                    .buttonStyle(.styled(style: .primary()))
                
                Button("Secondary Button") {}
                    .buttonStyle(.styled(style: .secondary()))
                
                Button("Inverted Button") {}
                    .buttonStyle(.styled(style: .inverted))
                
                Button("Ghost Button") {}
                    .buttonStyle(.styled(style: .ghost))
                
                Button("Text Button") {}
                    .buttonStyle(.styled(style: .text()))
            }
            
            Section("Button Shapes") {
                Button("Rounded Rectangle") {}
                    .buttonStyle(.styled(style: .primary(), shape: .roundedRectangle))
                
                Button("Capsule") {}
                    .buttonStyle(.styled(style: .primary(), shape: .capsule))
            }
            
            Section("Button Sizes") {
                Button("Large Button") {}
                    .buttonStyle(.styled(style: .primary(), size: .large))
                
                Button("Medium Button") {}
                    .buttonStyle(.styled(style: .primary(), size: .medium))
            }
            
            Section("Button Width") {
                Button("Fill Width") {}
                    .buttonStyle(.styled(style: .primary(), width: .fill))
                
                Button("Hug Content") {}
                    .buttonStyle(.styled(style: .primary(), width: .hug))
            }
            
            Section("Button with Icon") {
                Button("With Icon") {}
                    .buttonStyle(.styled(
                        style: .primary(),
                        leadingIcon: Image(systemName: "star")
                    ))
            }
            
            Section("Loading Button") {
                Button("Toggle Loading") {
                    isLoading.toggle()
                }
                
                Button("Loading Button") {}
                    .buttonStyle(.styled(
                        style: .primary(),
                        isLoading: isLoading
                    ))
            }
            
            Section("Destructive Button") {
                Button("Destructive") {}
                    .buttonStyle(.styled(
                        style: .primary(),
                        role: .destructive
                    ))
            }
        }
        .navigationTitle("Buttons")
    }
}

#Preview {
    NavigationView {
        ButtonsExampleView()
    }
} 
