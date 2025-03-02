import SwiftUI
import Design

public struct SettingsView: View {
    
    enum ProfileViews: String, CaseIterable {
        case about = "About"
        case editProfile = "Edit Profile"
        case buttonsShowcase = "Buttons Showcase"
    }
    
    @StateObject private var viewModel = SettingsViewModel()
    @EnvironmentObject private var coordinator: BuddiesProfileCoordinator
    @Environment(\.dismiss) var dismiss
    
    public init() {}
    
    public var body: some View {
        List {
            ForEach(ProfileViews.allCases, id: \.self) { selectedView in
                switch selectedView {
                case .about:
                    Button(action: {
                        coordinator.push(.about)
                    }) {
                        Text(selectedView.rawValue)
                    }
                    .buttonStyle(.styled(style: .ghost))

                case .editProfile:
                    Button(action: {
                        coordinator.push(.editProfile)
                    }) {
                        Text(selectedView.rawValue)
                    }
                    .buttonStyle(.styled(style: .ghost))
                case .buttonsShowcase:
                    Button(action: {
                        coordinator.push(.buttonsShowcase)
                    }) {
                        Text(selectedView.rawValue)
                    }
                    .buttonStyle(.styled(style: .ghost))
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    Task {
                        do {
                            try viewModel.signOut()
                        } catch {
                            debugPrint(error)
                        }
                    }
                } label: {
                    Image(systemName: "rectangle.portrait.and.arrow.right")
                        .foregroundStyle(.orange)
                }
            }
        }
    }
}

#Preview {
    SettingsView()
}
