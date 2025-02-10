import SwiftUI
import Design
import Auth

public struct AuthenticationView: View {
    @Environment(\.colorScheme) var colorScheme
    @StateObject private var viewModel: AuthenticationViewModel = .init()

    public init() {
    }
    
    public var body: some View {
        VStack(spacing: 20) {
            swiftBuddies
                .padding(.bottom)
            
            Group {
                googleSignInButton
                appleSignInButton
            }
            .clipShape(Capsule())
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }
}

extension AuthenticationView {
    private var swiftBuddies: some View {
        DesignAsset.swiftBuddiesImage.swiftUIImage
            .resizable()
            .aspectRatio(1, contentMode: .fit)
            .frame(height: 250)
    }
    
    private var googleSignInButton: some View {
        Button {
            do {
                try viewModel.signIn(provider: .google)
            } catch {
                debugPrint(error)
            }
        } label: {
            Text("Sign in with Google")
                .withLoginButtonFormatting()
        }
    }
    
    private var appleSignInButton: some View {
        Button {
            do {
                try viewModel.signIn(provider: .apple)
            } catch {
                debugPrint(error)
            }
        } label: {
            SignInWithAppleButtonViewRepresentable(type: .default, style: colorScheme == .light ? .black : .white)
                .allowsHitTesting(false)
                .withLoginButtonFormatting()
        }
    }
}
