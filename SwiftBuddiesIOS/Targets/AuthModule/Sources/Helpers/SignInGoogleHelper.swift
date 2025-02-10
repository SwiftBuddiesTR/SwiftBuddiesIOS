import Foundation
import GoogleSignIn

final class SignInGoogleHelper {
    
    @MainActor
    public func signIn() async throws -> SignInWithGoogleResult {
        guard let vc = UIApplication.shared.windows.first?.rootViewController else {
            throw URLError(.cannotFindHost)
        }

        let gidSignInResult = try await GIDSignIn.sharedInstance.signIn(withPresenting: vc)
        
        guard let idToken = gidSignInResult.user.idToken?.tokenString else {
            throw URLError(.badServerResponse)
        }
        
        let accessToken = gidSignInResult.user.accessToken.tokenString
        let name = gidSignInResult.user.profile?.name
        let email = gidSignInResult.user.profile?.email
        
        let tokens = SignInWithGoogleResult(idToken: idToken, accessToken: accessToken, name: name, email: email)
        return tokens
    }
    
}
