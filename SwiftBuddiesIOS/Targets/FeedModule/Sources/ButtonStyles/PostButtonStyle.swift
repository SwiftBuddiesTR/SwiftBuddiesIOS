//
//  PostButtonStyle.swift
//  SwiftBuddiesIOS
//
//  Created by dogukaan on 18.05.2024.
//

import SwiftUI

public struct PostButtonStyle: ButtonStyle {
    
    public enum Style {
        case like(Bool)
        case comment
        case save(Bool)
        case addPost(AddPostType)
    }
    public enum AddPostType {
        case icon
        case text
    }
    let style: Style
    
    @Environment(\.isEnabled) var isEnabled: Bool
    
    public func makeBody(configuration: Configuration) -> some View {
        buttonStyle(configuration: configuration)
    }
    
    @ViewBuilder
    func buttonStyle(configuration: Configuration) -> some View {
        switch style {
        case .like(let isToggled):
            VStack(spacing: 2) {
                Image(systemName: isToggled ? "heart.fill" : "heart")
                    .imageScale(.medium)
                    .foregroundColor(
                        (isToggled ? Color.red : Color.primary)
                            .opacity(configuration.isPressed ? 0.6 : 1)
                    )
                
                configuration.label
                    .font(.caption2)
                    .foregroundColor(
                        (isToggled ? Color.red : Color.primary)
                            .opacity(configuration.isPressed ? 0.6 : 1)
                    )
            }
            .frame(maxWidth: .infinity)
        case .save(let isToggled):
            VStack(spacing: 2) {
                Image(systemName: isToggled ? "bookmark.fill" : "bookmark")
                    .imageScale(.medium)
                    .foregroundColor(
                        (isToggled ? Color.yellow : Color.primary)
                            .opacity(configuration.isPressed ? 0.6 : 1)
                    )
                
                configuration.label
                    .font(.caption2)
                    .foregroundColor(
                        (isToggled ? Color.yellow : Color.primary)
                            .opacity(configuration.isPressed ? 0.6 : 1)
                    )
            }
            .frame(maxWidth: .infinity)
        case .comment:
            VStack(spacing: 2) {
                Image(systemName: "bubble.right")
                    .imageScale(.medium)
                    .foregroundColor(.primary.opacity(configuration.isPressed ? 0.6 : 1))
                
                configuration.label
                    .font(.caption2)
                    .foregroundColor(.primary.opacity(configuration.isPressed ? 0.6 : 1))
            }
            .frame(maxWidth: .infinity)
        case .addPost(let type):
            switch type {
            case .icon:
                Image(systemName: "plus.circle")
                    .imageScale(.medium)
                    .foregroundColor(.primary.opacity(configuration.isPressed ? 0.6 : 1))
                    .frame(maxWidth: .infinity)
            case .text:
                configuration.label
                    .font(.caption2)
                    .foregroundColor(.primary.opacity(configuration.isPressed ? 0.6 : 1))
                    .frame(maxWidth: .infinity)
            }
        }
    }
}


#Preview(body: {
    List {
        Section {
            Button { } label: {
                Text("Login")
            }
            .buttonStyle(.like(true))
        } header: { Text("Primary fill") }
        
        Section {
            Button { } label: {
                Text("Login")
            }
            .buttonStyle(.save(false))
        } header: { Text("Secondary fill icon") }
        
        Section {
            Button { } label: {
                Text("Login")
            }
            .buttonStyle(.comment)
        } header: { Text("Secondary fill") }
    }
})

// MARK: - Extend the button style
extension ButtonStyle where Self == PostButtonStyle {
    
    public static var comment: PostButtonStyle {
        PostButtonStyle(style: .comment)
    }
    
    public static func like(_ isToggled: Bool) -> Self {
        PostButtonStyle(style: .like(isToggled))
    }
    
    public static func save(_ isToggled: Bool) -> Self {
        PostButtonStyle(style: .save(isToggled))
    }
}

extension ButtonStyle where Self == PostButtonStyle {
    public static func addPost(_ type: PostButtonStyle.AddPostType) -> Self {
        PostButtonStyle(style: .addPost(type))
    }
}

