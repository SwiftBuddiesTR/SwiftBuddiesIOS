//
//  String+Extensionsi.swift
//  SwiftBuddiesIOS
//
//  Created by dogukaan on 7.01.2025.
//

import UIKit

public extension String {
    var imageFromBase64: UIImage? {
        guard let imageData = Data(base64Encoded: self, options: .ignoreUnknownCharacters) else {
            return nil
        }
        return UIImage(data: imageData)
    }
}
