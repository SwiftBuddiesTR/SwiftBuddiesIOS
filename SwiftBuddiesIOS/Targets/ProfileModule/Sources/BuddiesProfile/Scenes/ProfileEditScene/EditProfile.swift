//
//  EditProfile.swift
//  Buddies
//
//  Created by Fatih Özen on 13.01.2025.
//

import SwiftUI
import Design

struct EditProfile: View {
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    @StateObject private var viewModel = ProfileEditViewModel()
    @State private var showAlert = false
    
    var body: some View {
        Form {
            Section(header: Text("Kullanıcı Bilgileri")) {
                TextField("Username", text: $viewModel.username)
                    .disableAutocorrection(true)
                
                TextField("LinkedIn URL", text: $viewModel.linkedinURL)
                    .keyboardType(.URL)
                    .autocorrectionDisabled(true)
                
                TextField("GitHub URL", text: $viewModel.githubURL)
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
                    Text("Save")
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
        .navigationTitle("Edit Profile")
        .alert("Info!", isPresented: $showAlert) {
            Button("Ok", role: .cancel) {
                dismiss()
            }
        } message: {
            Text(viewModel.usernameMessage + ",\n " + viewModel.socialMessage)
        }
    }
}





