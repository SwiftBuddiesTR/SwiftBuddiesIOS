import Foundation
import Combine
import Auth
import Network
import BuddiesNetwork

@MainActor
final public class AuthenticationViewModel: ObservableObject {
    private let apiClient: BuddiesClient
    private var authManager: AuthWithSSOProtocol
//    @Dependency(\.authManager) var authManager
     
    public init() {
        self.authManager = AuthenticationManager(authService: .shared)
        self.apiClient = .shared
    }
    
    func signIn(provider: AuthProviderOption) throws {
        Task {
            try await authManager.signIn(provider: provider)
        }
    }
}
