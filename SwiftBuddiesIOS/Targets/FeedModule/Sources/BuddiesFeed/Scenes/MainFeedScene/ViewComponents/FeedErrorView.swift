//
//  File.swift
//  SwiftBuddiesIOS
//
//  Created by dogukaan on 2.03.2025.
//

import SwiftUI

// MARK: - Error View
struct FeedErrorView: View {
    let error: FeedState.FeedError
    let onRetry: () -> Void
    
    var body: some View {
        VStack {
            Text(error.localizedDescription)
                .multilineTextAlignment(.center)
                .padding()
            
            Button("Try Again", action: onRetry)
                .withLoginButtonFormatting()
        }
    }
}
