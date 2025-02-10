//
//  OnboardingBuilder.swift
//  Onboarding
//
//  Created by Halit Baskurt on 16.04.2024.
//

import Design
import Localization

public struct OnboardingBuilder {
    public static func build() -> OnboardingView {
        
        let onboardingItems: [OnboardingItemModel] = [
            .init(id: 0,
                  title: L.$onboardingitem_firsttitle.localized,
                  description: L.$onboardingitem_firstdescription.localized,
                  image: DesignAsset.onboardingWelcomeImage.swiftUIImage),
            .init(id: 1,
                  title: L.$onboardingitem_secondtitle.localized,
                  description: L.$onboardingitem_seconddescription.localized,
                  image: DesignAsset.onboardingBuddiesImage.swiftUIImage)
        ]
        
        return OnboardingView(items: onboardingItems)
    }
}
