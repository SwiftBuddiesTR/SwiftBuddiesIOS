import SwiftUI
import Design
import Localization

public struct SettingsView: View {
    
    enum ProfileViews: String, CaseIterable {
        case about = "About"
        case editProfile = "Edit Profile"
        case buttonsShowcase = "Buttons Showcase"
        
        var localized: String {
            switch self {
            case .about:
                return L.$settings_about.localized
            case .editProfile:
                return L.$profile_title_edit.localized
            case .buttonsShowcase:
                return L.$settings_buttons_showcase.localized
            }
        }
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
                        Text(selectedView.localized)
                    }
                    .buttonStyle(.styled(style: .inverted))

                case .editProfile:
                    Button(action: {
                        coordinator.push(.editProfile)
                    }) {
                        Text(selectedView.localized)
                    }
                    .buttonStyle(.styled(style: .secondary(color: DesignAsset.Colors.beaver.swiftUIColor)))
                case .buttonsShowcase:
                    Button(action: {
                        coordinator.push(.buttonsShowcase)
                    }) {
                        Text(selectedView.localized)
                    }
                    .buttonStyle(.styled(style: .ghost(color: DesignAsset.Colors.olive.swiftUIColor)))
                }
            }
            .listRowSeparator(.hidden)
        }
        .listStyle(.plain)
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
