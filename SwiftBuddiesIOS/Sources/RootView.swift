import SwiftUI
import Login
import Onboarding
import Design
import Auth

struct RootView: View {
    @AppStorage("isSplashScreenViewed") var isOnboardingScreenViewed : Bool = false
    @State private var isLoggedOut: Bool = true

    let loggedOut = NotificationCenter.default.publisher(for: .didLoggedOut)
    let loggedIn = NotificationCenter.default.publisher(for: .didLoggedIn)
    
    init() { }

    var body: some View {
        SuitableRootView()
    }
    
    @ViewBuilder
    private func SuitableRootView() -> some View {
        if isOnboardingScreenViewed {
            ZStack {
                if !isLoggedOut {
                    TabFlowView()
                } else {
                    AuthenticationView()
                }
            }
            .onReceive(loggedOut) { _ in
                isLoggedOut = true
            }
            .onReceive(loggedIn) { _ in
                isLoggedOut = false
            }
            .task {
                await BuddiesAuthenticationService.shared.checkIfLoggedIn()
            }
        } else {
            OnboardingBuilder.build()
        }
    }
}

#Preview {
    RootView()
}
