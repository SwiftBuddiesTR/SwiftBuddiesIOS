//
//  EditProfile.swift
//  Buddies
//
//  Created by Fatih Özen on 13.01.2025.
//

import SwiftUI
import Design
import Localization

struct EditProfile: View {
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    @StateObject private var viewModel = ProfileEditViewModel()
    @State private var showAlert = false
    
    var body: some View {
        Form {
            Section(header: L.profile_section_user_info) {
                TextField(L.$profile_field_username.localized, text: $viewModel.username)
                    .disableAutocorrection(true)
                
                TextField(L.$textfield_linkedin_url.localized, text: $viewModel.linkedinURL)
                    .keyboardType(.URL)
                    .autocorrectionDisabled(true)
                
                TextField(L.$textfield_github_url.localized, text: $viewModel.githubURL)
                    .keyboardType(.URL)
                    .autocorrectionDisabled(true)
            }
            
            Section {
                Button(action: {
                    Task {
                        await viewModel.saveProfile()
                        showAlert = true
                    }
                }) {
                    L.button_save
                        .frame(maxWidth: .infinity)
                        .font(.system(size: 24, weight: .bold))
                    
                }
                .buttonStyle(.styled(style: .secondary()))
                .disabled(viewModel.username.isEmpty)
                
            }
            .foregroundStyle(viewModel.username.isEmpty ? .white.opacity(0.9) : .white)
            .listRowBackground(viewModel.username.isEmpty ? Color.gray : Color.orange)
            .background(viewModel.username.isEmpty ? Color.gray : Color.orange)
            
        }
        .task {
            await viewModel.getProfileInfos()
        }
        .navigationBarTitleDisplayMode(.automatic)
        .navigationTitle(L.$profile_title_edit.localized)
        .alert(L.$alert_info_title.localized, isPresented: $showAlert) {
            Button(L.$alert_info_button_ok.localized, role: .cancel) {
                dismiss()
            }
        } message: {
            Text(viewModel.usernameMessage + ",\n " + viewModel.socialMessage)
        }
    }
}





