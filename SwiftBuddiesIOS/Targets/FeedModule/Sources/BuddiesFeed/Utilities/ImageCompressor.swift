import UIKit

enum ImageCompressor {
    static let maxFileSize = 3 * 1024 * 1024 // 10MB in bytes
    
    /// Compresses an image while maintaining maximum possible quality under maxFileSize
    /// - Parameters:
    ///   - image: UIImage to compress
    ///   - maxSize: Maximum size in bytes (default 10MB)
    /// - Returns: Compressed image data
    static func compress(
        image: UIImage,
        maxSize: Int = maxFileSize
    ) async -> Data? {
        // Start with original size
        guard let imageData = image.jpegData(compressionQuality: 1.0) else {
            return nil
        }
        
        // If already under maxSize, return original
        if imageData.count <= maxSize {
            return imageData
        }
        
        // Use progressive resizing if image is too large
        if let resizedImage = await image.checkAndResizeImageNew(0.98, maxSize) {
            return resizedImage.jpegData(compressionQuality: 1.0)
        }
        
        return nil
    }
}

// MARK: - UIImage Extension
extension UIImage {
    fileprivate func checkAndResizeImageNew(
        _ resizingPercent: CGFloat = 0.98,
        _ threshold: Int = 10_000_000
    ) async -> UIImage? {
        guard let data = self.jpegData(compressionQuality: 1) else { return nil }
        
        let newImageHere = Task { @MainActor in
            if data.count > threshold {
                let image = self.resizeWithPercent(percentage: resizingPercent)
                return await image?.checkAndResizeImageNew(resizingPercent - 0.04)
            } else {
                return self
            }
        }
        
        return await newImageHere.value
    }
    
    fileprivate func resizeWithPercent(percentage: CGFloat) -> UIImage? {
        let imageView = UIImageView(
            frame: CGRect(
                origin: .zero,
                size: CGSize(width: size.width * percentage, height: size.height * percentage)
            )
        )
        imageView.contentMode = .scaleAspectFit
        imageView.image = self
        
        UIGraphicsBeginImageContextWithOptions(
            imageView.bounds.size,
            false,
            scale
        )
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.render(in: context)
        guard let result = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return result
    }
} 
