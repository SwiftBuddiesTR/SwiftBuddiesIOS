//
//  DismissableMessage.swift
//  SwiftBuddiesMain
//
//  Created by dogukaan on 28.01.2024.
//  Copyright © 2024 SwiftBuddies. All rights reserved.
//

import SwiftUI

public struct DismissableMessage<MessageView: View>: View {
    @Binding var displayMessage: Bool
    var delay: Double = 3.0
    var messageView: () -> MessageView
    
    public init(displayMessage: Binding<Bool> = .constant(false), delay: Double = 3.0, @ViewBuilder messageView: @escaping () -> MessageView) {
        self._displayMessage = displayMessage
        self.delay = delay
        self.messageView = messageView
    }
    
    public var body: some View {
        Group {
            if displayMessage {
                messageView()
            }
        }
        .onAppear(perform: showThenHide)
    }
    
    func showThenHide() {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            withAnimation {
                displayMessage = false
            }
        }
    }
}
