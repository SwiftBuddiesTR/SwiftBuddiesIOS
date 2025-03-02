import Foundation
import Auth

@MainActor
final class SettingsViewModel: ObservableObject {
    func signOut() throws {
        try AuthenticationManager.shared.signOut()
    }
}
