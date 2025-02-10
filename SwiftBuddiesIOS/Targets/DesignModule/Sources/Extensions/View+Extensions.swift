//
//  View+Extensions.swift
//  SwiftBuddiesMain
//
//  Created by dogukaan on 28.01.2024.
//  Copyright © 2024 SwiftBuddies. All rights reserved.
//

import SwiftUI

public extension View {
    @ViewBuilder
    func bottomSheet<Content: View>(
        presentationDetents: Set<PresentationDetent> = [.large],
        detentSelection: Binding<PresentationDetent>,
        isPresented: Binding<Bool>,
        dragIndicator: Visibility = .visible,
        sheetCornerRadius: CGFloat?,
        largestUndimmedIdentifier: UISheetPresentationController.Detent.Identifier = .large,
        isTranspartentBG: Bool = false,
        interactiveDismissDisabled: Bool = true,
        backgroundInteraction: PresentationBackgroundInteraction = .enabled,
        @ViewBuilder content: @escaping () -> Content,
        onDismiss: @escaping () -> Void
    ) -> some View {
        self.sheet(isPresented: isPresented) {
            onDismiss()
        } content: {
            content()
                .presentationDetents(presentationDetents, selection: detentSelection)
                .presentationDragIndicator(dragIndicator)
                .interactiveDismissDisabled(interactiveDismissDisabled)
                .presentationBackgroundInteraction(backgroundInteraction)
                .onAppear {
                    guard let windows = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
                        return
                    }
                    if let controller = windows.windows.first?.rootViewController?.presentedViewController,
                       let sheet = controller.presentationController as? UISheetPresentationController {
                        sheet.largestUndimmedDetentIdentifier = largestUndimmedIdentifier
                        sheet.preferredCornerRadius = sheetCornerRadius
                    } else {
                        debugPrint("No controller found")
                    }
                }
        }
    }
    
    func fillView(_ color: Color, horizontolPadding: CGFloat = 15, verticalPadding: CGFloat = 10) -> some View {
        self
            .padding(.horizontal,horizontolPadding)
            .padding(.vertical,verticalPadding)
            .background { color }
    }
    
    func endTextEditing() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

public extension Binding where Value == Bool {
    var negated: Binding<Bool> {
        return Binding<Bool>(
            get: { !self.wrappedValue },
            set: { self.wrappedValue = !$0 }
        )
    }
}

public extension View {
    func withLoginButtonFormatting() -> some View {
        modifier(LoginButtonViewModifier())
    }
}
