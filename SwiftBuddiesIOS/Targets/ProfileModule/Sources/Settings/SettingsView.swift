import SwiftUI
import Design

struct SettingsView: View {
    
    @StateObject private var viewModel = SettingsViewModel()
    
    var body: some View {
        List {
            Button("Sign out") {
                Task {
                    do {
                        try viewModel.signOut()
                    } catch {
                        debugPrint(error)
                    }
                }
            }
        }
        .navigationBarTitle("Settings")
    }
}

#Preview {
    SettingsView()
}
