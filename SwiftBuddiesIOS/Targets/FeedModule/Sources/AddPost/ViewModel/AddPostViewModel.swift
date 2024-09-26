//
//  AddPostViewModel.swift
//  Feed
//
//  Created by Kate Kashko on 15.04.2024.
//  Copyright © 2024 SwiftBuddies. All rights reserved.
//

import PhotosUI
import SwiftUI

@MainActor
class AddPostViewModel: ObservableObject {
    
    @Published var selectedImage: PhotosPickerItem? {
        didSet { Task { await loadImage(fromItem:selectedImage) } }
    }
    
    @Published var postImage: Image?
    
    func loadImage(fromItem item: PhotosPickerItem?) async {
        guard let item = item else { return }
        
        guard let data  = try? await item.loadTransferable(type: Data.self) else { return }
        guard let uiImage = UIImage(data: data) else { return }
        self.postImage = Image(uiImage: uiImage)
    }
}
