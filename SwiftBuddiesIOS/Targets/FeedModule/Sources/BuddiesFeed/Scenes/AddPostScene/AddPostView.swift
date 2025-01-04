//
//  File.swift
//  Feed
//
//  Created by dogukaan on 4.01.2025.
//

import SwiftUI
import Design

struct AddPostView: View {
    @StateObject private var viewModel = AddPostViewModel()
    @EnvironmentObject private var coordinator: BuddiesFeedCoordinator
    
    init() {}
    
    var body: some View {
        VStack(spacing: 16) {
            TextEditor(text: $viewModel.postContent)
                .frame(height: 150)
                .padding(8)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
            
            Button(action: {
                Task {
                    await viewModel.createPost()
                    coordinator.popToRoot()
                }
            }) {
                Text("Share Post")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.cyan)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .disabled(viewModel.isLoading || viewModel.postContent.isEmpty)
            
            if viewModel.isLoading {
                ProgressView()
            }
        }
        .padding()
        .navigationTitle("New Post")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Cancel") {
                    coordinator.popToRoot()
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        AddPostView()
    }
} 
