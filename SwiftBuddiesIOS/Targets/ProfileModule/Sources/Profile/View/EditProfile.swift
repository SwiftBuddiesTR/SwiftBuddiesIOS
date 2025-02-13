//
//  EditProfile.swift
//  Buddies
//
//  Created by Fatih Özen on 13.01.2025.
//

import SwiftUI

struct EditProfile: View {
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    @StateObject private var viewModel = ProfileEditViewModel()
    
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
                        dismiss()
                    }
                }) {
                    Text("Kaydet")
                        .frame(maxWidth: .infinity)
                        .font(.system(size: 24, weight: .bold))
                        .foregroundStyle(.white)
                }
            }
            .listRowBackground(Color.orange)
            .background(Color.orange)
            
        }
        .task {
            await viewModel.getProfileInfos()
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Edit Profile")
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
        }
        
    }
}





