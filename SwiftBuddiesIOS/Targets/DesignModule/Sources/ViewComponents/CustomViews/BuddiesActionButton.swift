//
//  BuddiesActionButton.swift
//  Design
//
//  Created by Halit Baskurt on 16.04.2024.
//

import SwiftUI

public struct BuddiesActionButton: View {
    
    public init(
        label: Text,
        bgColor: Color = .orange,
        iconName: String = "",
        clickAction: @escaping () -> Void
    ) {
        self.label = label
        self.bgColor = bgColor
        self.iconName = iconName
        self.clickAction = clickAction
    }
    
    public let label: Text
    public let bgColor: Color
    public var iconName: String
    public let clickAction: () -> Void
    
    public var body: some View {
        HStack {
            Button(action: { clickAction() }) {
                HStack {
                    if !iconName.isEmpty {
                        Image(systemName: "person")
                            .resizable()
                            .frame(width: 40,height: 40)
                            .foregroundStyle(.white)
                    } else { EmptyView() }
                }
                label
                    .font(.body.bold())
                    .foregroundStyle(.white)
                    .frame(height: 40)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            .fillView(bgColor)
            .clipShape(
                .rect(
                    topLeadingRadius: 10,
                    bottomLeadingRadius: 10,
                    bottomTrailingRadius: 10,
                    topTrailingRadius: 10
                )   
            )
        }
        .frame(maxWidth: .infinity)
    }
}
