import UIKit

struct PostImage: Identifiable, Equatable {
    var id: String
    let image: UIImage
    let data: Data?
    var isUploaded: Bool = false
    var isUploading: Bool = false
    var error: String?
    var base64Value: String?
    
    init(id: String = UUID().uuidString, image: UIImage) {
        self.id = id
        self.image = image
        self.data = image.heicData()
        self.base64Value = data?.base64EncodedString()
    }
} 
