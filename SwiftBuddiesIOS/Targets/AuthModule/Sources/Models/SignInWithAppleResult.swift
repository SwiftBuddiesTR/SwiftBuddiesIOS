import Foundation

public struct SignInWithAppleResult {
    let token: String
    let nonce: String
    let name: String?
    let email: String?
}
