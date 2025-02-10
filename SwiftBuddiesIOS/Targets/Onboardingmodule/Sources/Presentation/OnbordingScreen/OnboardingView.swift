//
//  OnboardingView.swift
//  Onboarding
//
//  Created by Halit Baskurt on 16.04.2024.
//

import SwiftUI
import Design
import Localization

public struct OnboardingView: View {
    @AppStorage("isSplashScreenViewed") var isOnboardingScreenViewed : Bool = false
    
    init(items onboardingData:[OnboardingItemModel]) {
        self.onboardingData = onboardingData
    }
    
    @State private var currentOnboardingItem: Int = 0
    
    private var onboardingData: [OnboardingItemModel]

    
    public var body: some View {
        ZStack {
            DesignAsset.onboardingBackround.swiftUIColor
                .ignoresSafeArea()
            VStack {
                TabView(selection: $currentOnboardingItem) {
                    ForEach(0..<onboardingData.count, id: \.self) { index in
                        let model = onboardingData[index]
                        OnboardingCell(model: model)
                            .tag(index)
                    }.padding(.horizontal, 20)
                }
                .tabViewStyle(.page(indexDisplayMode: .always))
                .padding(.top,20)
                .onAppear { setPageIndicatorColor() }
                let isLastItem: Bool = onboardingData.count - 1 == currentOnboardingItem
                BuddiesActionButton(label: isLastItem ? L.onboarding_startbuttontitle: L.onboarding_buttontitle) {
                    if isLastItem {
                        withAnimation(.easeInOut) { isOnboardingScreenViewed = true }
                        
                    } else {
                        withAnimation { currentOnboardingItem += 1 }
                    }
                }
                .padding(.horizontal)
            }.padding()
        }
    }
    
    func setPageIndicatorColor() {
        UIPageControl
            .appearance()
            .currentPageIndicatorTintColor = .orange
        UIPageControl
            .appearance()
            .pageIndicatorTintColor = .orange
            .withAlphaComponent(0.2)
    }
}

