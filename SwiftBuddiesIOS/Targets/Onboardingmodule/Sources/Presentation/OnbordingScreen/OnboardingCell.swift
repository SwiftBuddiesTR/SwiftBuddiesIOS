//
//  OnboardingCell.swift
//  Onboarding
//
//  Created by Halit Baskurt on 16.04.2024.
//

import SwiftUI
import Design

struct OnboardingCell: View {
    
    let model: OnboardingItemModel
    
    var body: some View {
        VStack {
            ZStack {
                HalfCapsule()
                    .foregroundStyle(.white)
                    .rotationEffect(.degrees(180))
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 300)
                model.image
                    .resizable()
                    .padding(.horizontal)
                    .aspectRatio(contentMode: .fit)
            }
            Text(model.title)
                .font(.system(size: 30,weight: .bold))
                .multilineTextAlignment(.center)
                .padding(.bottom,10)
            Text(model.description)
                .multilineTextAlignment(.center)
            Spacer()
        }
        .frame(maxWidth: .infinity,maxHeight: .infinity)
        .ignoresSafeArea(edges: .bottom)
    }
}
