//
//  AddPostContentView.swift
//  Feed
//
//  Created by Kate Kashko on 15.04.2024.
//  Copyright © 2024 SwiftBuddies. All rights reserved.
//

import SwiftUI

struct AddPostContentView: View {
    @ObservedObject var viewModel: AddPostViewModel
    @Binding var imagePickerPresented: Bool
    @State private var customTF = ""
    let placeholder = "What is new?"
    
    var body: some View {
        ScrollView {
            VStack {
                
                // MARK: - Message
                
                TextEditor(text: $customTF)
                    .foregroundColor(customTF.isEmpty ? .gray : .primary)
                    .overlay(
                        customTF.isEmpty ? Text(placeholder).foregroundColor(.gray).padding(.all, 4) : nil, alignment: .topLeading
                    )
                    .padding()
                    .frame(minHeight: 100)
                
                // MARK: - Image
                
                if let image = viewModel.postImage {
                    ZStack(alignment: .topTrailing) {
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: 300, maxHeight: 250)
                            .clipped()
                        
                        HStack {
                            Button(action: {
                                imagePickerPresented.toggle()
                            }) {
                                Image(systemName: "pencil.circle.fill")
                                
                                    .imageScale(.large)
                                    .symbolRenderingMode(.palette)
                                    .foregroundStyle(Color.white, Color.cyan)
                            }
                            
                            Button(action: {
                                viewModel.postImage = nil
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                
                                    .imageScale(.large)
                                    .symbolRenderingMode(.palette)
                                    .foregroundStyle(Color.white, Color.cyan)
                            }
                        }
                        .padding([.top, .trailing], 10)
                    }
                }
            }
        }
    }
}

//#Preview {
//    AddPostContentView()
//}
