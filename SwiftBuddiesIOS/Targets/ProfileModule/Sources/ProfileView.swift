import SwiftUI
import Design

public struct ProfileView: View {
    
    public init() { }
    
    enum ProfileViews: String, CaseIterable {
        case about = "About"
        case settings = "Settings"
    }
    
    public var body: some View {
        NavigationStack {
            List {
                ForEach(ProfileViews.allCases, id: \.self) { selectedView in
                    NavigationLink(selectedView.rawValue) {
                        switch selectedView {
                        case .about:
                            AboutView()
                        case .settings:
                            SettingsView()
                        }
                    }
                }
            }
            .navigationTitle("Profile")
        }
    }
}

#Preview {
    ProfileView()
}
