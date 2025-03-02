//
//  File.swift
//  SwiftBuddiesIOS
//
//  Created by dogukaan on 2.03.2025.
//

import SwiftUI

// MARK: - Post Images Carousel
public struct PostImagesCarousel: View {
    let imageIds: [String?]
    let postImages: [String: UIImage]
    
    public init(
        imageIds: [String?],
        postImages: [String : UIImage]
    ) {
        self.imageIds = imageIds
        self.postImages = postImages
    }
    
    public var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(imageIds.compactMap { $0 }, id: \.self) { imageId in
                    if let image = postImages[imageId] {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 200, height: 200)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    } else {
                        ProgressView()
                            .frame(width: 200, height: 200)
                    }
                }
            }
        }
    }
}
