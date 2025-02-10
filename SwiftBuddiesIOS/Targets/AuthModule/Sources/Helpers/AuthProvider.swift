import Foundation

public protocol AuthProvider {
    func signIn() async throws -> SignInRequest
}

public class GoogleAuthenticationProvider: AuthProvider {
    
    public init() { }
    
    public func signIn() async throws -> SignInRequest {
        let helper = SignInGoogleHelper()
        let tokens = try await helper.signIn()
        return SignInRequest(
            accessToken: tokens.accessToken,
            type: AuthProviderOption.google.rawValue
        )
    }
}

public class AppleAuthenticationProvider: AuthProvider {
    
    public init() { }
    
    public func signIn() async throws -> SignInRequest {
        let helper = await SignInAppleHelper()
        let tokens = try await helper.startSignInWithAppleFlow()
        return SignInRequest(
            accessToken: tokens.token,
            type: AuthProviderOption.apple.rawValue
        )
    }
}
