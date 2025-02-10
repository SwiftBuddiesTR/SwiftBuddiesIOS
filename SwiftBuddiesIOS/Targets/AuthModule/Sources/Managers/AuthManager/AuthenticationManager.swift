import Foundation

public enum AuthProviderOption: String {
    case google, apple
    
    var domainName: String { self.rawValue + ".com" }
}

public final class AuthenticationManager {
    public static var shared: AuthenticationManager!
    private let authService: BuddiesAuthenticationService
    
    public init(authService: BuddiesAuthenticationService) {
        self.authService = authService
    }
        
    public func signOut() throws {
        //signOut
        KeychainManager.shared.delete(.accessToken)
        Task {
            await authService.logout()
        }
    }
}

// MARK: SIGN IN SSO
public protocol AuthWithSSOProtocol {
    func signIn(provider: AuthProviderOption) async throws
}

extension AuthenticationManager: AuthWithSSOProtocol {
    public func signIn(provider: AuthProviderOption) async throws {
        let authProvider: AuthProvider = switch provider {
        case .google:
            GoogleAuthenticationProvider()
        case .apple:
            AppleAuthenticationProvider()
        }
        
        let credentials = try await authProvider.signIn()
        debugPrint(credentials)
        await authService.registerUser(signInRequest: .init(accessToken: credentials.accessToken, type: credentials.type))
//        await BuddiesAuthentication.shared.registerUser(signInRequest: credentials)
    }
}
