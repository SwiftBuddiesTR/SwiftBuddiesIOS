import SwiftUI
import PhotosUI

struct ImagePicker: View {
    @Binding var selectedImages: [PostImage]
    @Binding var isPresented: Bool
    let source: ImageSource
    let maxImages: Int
    
    enum ImageSource {
        case camera
        case photoLibrary
    }
    
    var body: some View {
        Group {
            switch source {
            case .camera:
                CameraPicker(selectedImages: $selectedImages, isPresented: $isPresented)
            case .photoLibrary:
                PhotoPicker(selectedImages: $selectedImages, isPresented: $isPresented, maxImages: maxImages)
            }
        }
    }
}

private struct CameraPicker: UIViewControllerRepresentable {
    @Binding var selectedImages: [PostImage]
    @Binding var isPresented: Bool
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: CameraPicker
        
        init(_ parent: CameraPicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.selectedImages.append(PostImage(image: image))
            }
            parent.isPresented = false
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.isPresented = false
        }
    }
}

private struct PhotoPicker: UIViewControllerRepresentable {
    @Binding var selectedImages: [PostImage]
    @Binding var isPresented: Bool
    let maxImages: Int
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = maxImages - selectedImages.count
        
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: PHPickerViewControllerDelegate {
        let parent: PhotoPicker
        
        init(_ parent: PhotoPicker) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            let group = DispatchGroup()
            var newImages: [PostImage] = []
            
            for result in results {
                guard result.itemProvider.canLoadObject(ofClass: UIImage.self) else { continue }
                
                group.enter()
                result.itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                    defer { group.leave() }
                    
                    if let image = image as? UIImage {
                        newImages.append(PostImage(image: image))
                    }
                }
            }
            
            group.notify(queue: .main) {
                self.parent.selectedImages.append(contentsOf: newImages)
                self.parent.isPresented = false
            }
        }
    }
} 
