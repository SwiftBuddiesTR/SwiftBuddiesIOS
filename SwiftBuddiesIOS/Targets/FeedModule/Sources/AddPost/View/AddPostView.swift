//
//  AddPostView.swift
//  Feed
//
//  Created by Kate Kashko on 15.04.2024.
//  Copyright © 2024 SwiftBuddies. All rights reserved.
//

import SwiftUI
import PhotosUI

struct AddPostView: View {
    @State private var isCameraViewPresented = false
    @State private var imagePickerPresented = false
    @ObservedObject var viewModel = AddPostViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                AddPostHeaderButtonsView()
                
                Divider()
                
                AddPostContentView(viewModel: viewModel, 
                                   imagePickerPresented: $imagePickerPresented
                )
                AddPhotoButton(isCameraViewPresented: $isCameraViewPresented,
                               imagePickerPresented: $imagePickerPresented,
                               viewModel: viewModel
                )
                    .padding(.vertical, 10)
            }
        }
    }
}

#Preview {
    AddPostView()
}
