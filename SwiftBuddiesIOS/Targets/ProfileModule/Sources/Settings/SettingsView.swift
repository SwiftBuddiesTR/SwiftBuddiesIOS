import SwiftUI
import Design

struct SettingsView: View {
    
    enum ProfileViews: String, CaseIterable {
        case about = "About"
        case editProfile = "Edit Profile"
    }
    
//    @StateObject private var viewModel = SettingsViewModel()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
            List {
                ForEach(ProfileViews.allCases, id: \.self) { selectedView in
                    NavigationLink(selectedView.rawValue) {
                        switch selectedView {
                        case .about:
                            AboutView()
                        case .editProfile:
                            EditProfile()
                        }
                    }
                    .foregroundStyle(Color.dynamicColor)
                }
            }
            .navigationTitle("Settings")
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .foregroundStyle(Color.dynamicColor)
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
//                        Task {
//                            do {
//                                try viewModel.signOut()
//                            } catch {
//                                debugPrint(error)
//                            }
//                        }
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
