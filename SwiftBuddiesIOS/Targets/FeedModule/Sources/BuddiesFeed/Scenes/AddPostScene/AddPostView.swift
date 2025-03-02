//
//  File.swift
//  Feed
//
//  Created by dogukaan on 4.01.2025.
//

import SwiftUI
import Design
import Localization

struct AddPostView: View {
    @StateObject private var viewModel = AddPostViewModel()
    @EnvironmentObject private var coordinator: BuddiesFeedCoordinator
    @FocusState private var isFocused: Bool
    
    @State private var showingImagePicker = false
    @State private var showingSourcePicker = false
    @State private var selectedSource: ImagePicker.ImageSource?
    
    var body: some View {
        VStack(spacing: 0) {
            // Text Editor and Image
            ScrollView {
                VStack(spacing: 16) {
                    ZStack(alignment: .topLeading) {
                        TextEditor(text: $viewModel.postContent)
                            .frame(maxWidth: .infinity, minHeight: 150)
                            .padding(.horizontal)
                            .focused($isFocused)
                        
                        if viewModel.postContent.isEmpty {
                            Text(L.$feed_whats_on_your_mind.localized)
                                .foregroundColor(.gray.opacity(0.8))
                                .padding(.horizontal, 20)
                                .padding(.top, 8)
                        }
                    }
                    
                    if !viewModel.selectedImages.isEmpty {
                        imagesPreview
                    }
                }
                .padding(.vertical)
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
                    Button(action: { showingSourcePicker = true }) {
                        Image(systemName: "photo")
                            .font(.title2)
                            .foregroundColor(viewModel.canAddMoreImages ? .cyan : .gray)
                    }
                    .disabled(!viewModel.canAddMoreImages)
                    
                    Text("\(viewModel.postContent.count)/\(viewModel.maxCharacterCount)")
                        .font(.caption)
                        .foregroundColor(
                            viewModel.postContent.count > viewModel.maxCharacterCount ? .red : .gray
                        )
                    
                    Spacer()
                    
                    shareButton
                }
                .padding()
            }
            .background(Color(uiColor: .systemBackground))
            .shadow(color: .black.opacity(0.05), radius: 8, y: -4)
        }
        .navigationTitle(L.$feed_new_post.localized)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(L.$button_cancel.localized) {
                    coordinator.pop()
                }
                .foregroundColor(.red)
            }
        }
        .onAppear { isFocused = true }
        .confirmationDialog(L.$imagepicker_choose_source.localized, isPresented: $showingSourcePicker) {
            Button(L.$imagepicker_camera.localized) { 
                selectedSource = .camera
                showingImagePicker = true
            }
            Button(L.$imagepicker_photo_library.localized) { 
                selectedSource = .photoLibrary
                showingImagePicker = true
            }
            Button(L.$button_cancel.localized, role: .cancel) {}
        }
        .sheet(isPresented: $showingImagePicker) {
            if let source = selectedSource {
                ImagePicker(
                    selectedImages: $viewModel.selectedImages,
                    isPresented: $showingImagePicker,
                    source: source,
                    maxImages: viewModel.maxImages
                )
            }
        }
        .onChange(of: showingImagePicker) {
            Task {
                await viewModel.handleNewImages()
            }
        }
    }
    
    private var shareButton: some View {
        Button(action: {
            Task {
                await viewModel.createPost()
                coordinator.popToRoot()
            }
        }) {
            L.button_share
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
    
    private func imagePreview(_ image: PostImage) -> some View {
        ZStack(alignment: .topTrailing) {
            ZStack {
                Image(uiImage: image.image)
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                
                if image.isUploading {
                    ProgressView()
                        .background(Color.black.opacity(0.3))
                }
                
                if let error = image.error {
                    VStack {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundColor(.yellow)
                        Text(error)
                            .font(.caption)
                            .foregroundColor(.white)
                    }
                    .padding()
                    .background(Color.black.opacity(0.7))
                }
            }
            
            Button {
                viewModel.removeImage(with: image.id)
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.white)
                    .background(Color.black.opacity(0.5))
                    .clipShape(Circle())
            }
            .padding(8)
        }
        .padding(.horizontal)
    }
    
    private var buttonBackgroundColor: Color {
        viewModel.isValid ? .cyan : .gray.opacity(0.3)
    }
    
    private var imagesPreview: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(viewModel.selectedImages) { image in
                    imagePreview(image)
                }
            }
            .padding(.horizontal)
        }
    }
}

#Preview {
    NavigationStack {
        AddPostView()
    }
} 
