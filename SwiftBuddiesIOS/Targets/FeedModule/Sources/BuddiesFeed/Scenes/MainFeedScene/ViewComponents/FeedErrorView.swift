//
//  File.swift
//  SwiftBuddiesIOS
//
//  Created by dogukaan on 2.03.2025.
//

import SwiftUI
import Localization

// MARK: - Error View
struct FeedErrorView: View {
    let error: FeedState.FeedError
    let onRetry: () -> Void
    
    var body: some View {
        VStack {
            Text(error.localizedDescription)
                .multilineTextAlignment(.center)
                .padding()
            
            Button(L.$button_try_again.localized, action: onRetry)
                .withLoginButtonFormatting()
        }
    }
}
