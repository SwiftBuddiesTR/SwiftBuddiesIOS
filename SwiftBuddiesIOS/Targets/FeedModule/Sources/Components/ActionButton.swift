//
//  ActionButton.swift
//  Feed
//
//  Created by Kate Kashko on 15.04.2024.
//  Copyright © 2024 SwiftBuddies. All rights reserved.
//

import SwiftUI

struct ActionButton: View {
    let action: () -> Void
    let systemImageName: String
    let label: String
    let isToggled: Bool
    let toggledColor: Color

    init(systemImageName: String, label: String, isToggled: Bool, toggledColor: Color, action: @escaping () -> Void) {
            self.action = action
            self.systemImageName = systemImageName
            self.label = label
            self.isToggled = isToggled
            self.toggledColor = toggledColor
        }
    
    var body: some View {
        Button {
            action()
        } label: {
            VStack(spacing: 2) {
                Image(systemName: systemImageName)
                    .imageScale(.medium)
                    .foregroundColor(isToggled ? toggledColor : .primary)

                Text(label)
                    .font(.caption2)
                    .foregroundColor(isToggled ? toggledColor : .primary)
            }
        }
    }
}
