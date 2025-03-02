//
//  SocialActionButton.swift
//  Design
//
//  Created by dogukaan on 2.03.2025.
//

import SwiftUI

public struct SocialActionButton: View {
    public enum ActionType {
        case like
        case comment
        
        var icon: String {
            switch self {
            case .like:
                return "heart"
            case .comment:
                return "bubble.right"
            }
        }
        
        var selectedIcon: String {
            switch self {
            case .like:
                return "heart.fill"
            case .comment:
                return "bubble.right.fill"
            }
        }
    }
    
    let type: ActionType
    let count: Int
    @Binding var isSelected: Bool
    
    public init(
        type: ActionType,
        count: Int = 0,
        isSelected: Binding<Bool>
    ) {
        self.type = type
        self.count = count
        self._isSelected = isSelected
    }
    
    public var body: some View {
        Button(action: {
            isSelected.toggle()
        }) {
            HStack(spacing: 4) {
                Image(systemName: isSelected ? type.selectedIcon : type.icon)
                    .font(.system(size: 16))
                
                Text("\(count)")
                    .font(.system(size: 14, weight: .medium))
            }
            .foregroundColor(isSelected ? iconColor : .gray)
            .padding(.vertical, 6)
            .padding(.horizontal, 12)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
    
    private var iconColor: Color {
        switch type {
        case .like:
            return .red
        case .comment:
            return .blue
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        HStack(spacing: 16) {
            SocialActionButton(type: .like, count: 42, isSelected: .constant(false))
            SocialActionButton(type: .comment, count: 12, isSelected: .constant(false))
        }
        
        HStack(spacing: 16) {
            SocialActionButton(type: .like, count: 42, isSelected: .constant(true))
            SocialActionButton(type: .comment, count: 12, isSelected: .constant(true)) 
        }
    }
    .padding()
    .previewLayout(.sizeThatFits)
} 
