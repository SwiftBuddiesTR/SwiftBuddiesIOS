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
    @FocusState private var isFocused: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            // Text Editor
            ZStack(alignment: .topLeading) {
                TextEditor(text: $viewModel.postContent)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding(.horizontal)
                    .focused($isFocused)
                
                if viewModel.postContent.isEmpty {
                    Text("What's on your mind?")
                        .foregroundColor(.gray.opacity(0.8))
                        .padding(.horizontal, 20)
                        .padding(.top, 8)
                }
            }
            
            Divider()
            
            // Bottom Bar
            VStack(spacing: 16) {
                if viewModel.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity)
                        .padding(.top)
                }
                
                HStack {
                    Text("\(viewModel.postContent.count)/\(viewModel.maxCharacterCount)")
                        .font(.caption)
                        .foregroundColor(
                            viewModel.postContent.count > viewModel.maxCharacterCount ? .red : .gray
                        )
                    
                    Spacer()
                    
                    Button(action: {
                        Task {
                            await viewModel.createPost()
                            coordinator.popToRoot()
                        }
                    }) {
                        Text("Share")
                            .fontWeight(.semibold)
                            .padding(.horizontal, 24)
                            .padding(.vertical, 8)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(buttonBackgroundColor)
                            )
                            .foregroundColor(.white)
                    }
                    .disabled(!viewModel.isValid)
                }
                .padding()
            }
            .background(Color(uiColor: .systemBackground))
            .shadow(color: .black.opacity(0.05), radius: 8, y: -4)
        }
        .navigationTitle("New Post")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Cancel") {
                    coordinator.popToRoot()
                }
                .foregroundColor(.red)
            }
        }
        .onAppear {
            isFocused = true
        }
    }
    
    private var buttonBackgroundColor: Color {
        viewModel.isValid ? .cyan : .gray.opacity(0.3)
    }
}

#Preview {
    NavigationStack {
        AddPostView()
    }
} 
