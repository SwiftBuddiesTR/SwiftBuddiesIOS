//
//  AddPhotoButton.swift
//  Feed
//
//  Created by Kate Kashko on 15.04.2024.
//  Copyright © 2024 SwiftBuddies. All rights reserved.
//

import SwiftUI

struct AddPhotoButton: View {
    @Binding var isCameraViewPresented: Bool
    @Binding var imagePickerPresented: Bool
    @ObservedObject var viewModel: AddPostViewModel
    
    var body: some View {
        HStack {
            Button(action: {
                isCameraViewPresented.toggle()
            }) {
                Image(systemName: "camera.fill")
                    .foregroundColor(.gray)
                    .imageScale(.large)
                    .frame(width: 50, height: 50)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.cyan, lineWidth: 2)
                            )
                    )
            }
            .fullScreenCover(isPresented: $isCameraViewPresented) {
                CameraView()
            }
            Button(action: {
                imagePickerPresented.toggle()
            }) {
                Image(systemName: "photo.badge.plus")
                    .foregroundColor(.gray)
                    .imageScale(.large)
                    .frame(width: 50, height: 50)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.cyan, lineWidth: 2)
                            )
                    )
            }
            .photosPicker(isPresented: $imagePickerPresented, selection: $viewModel.selectedImage)
        }
    }
}

//#Preview {
//    AddPhotoButton()
//}
