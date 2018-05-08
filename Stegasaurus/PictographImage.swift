//
//  PictographImage.swift
//  Stegasaurus
//
//  Created by Elliott Williams on 5/7/18.
//  Copyright © 2018 AgrippaApps. All rights reserved.
//

import Foundation
import UIKit

class PictographImage: UIImage {
    let x = 1

}
extension PictographImage {
    func getReconciledImageWidth() -> Int {
        return Int(size.width * scale)
    }
    
    func getReconciledImageHeight() -> Int {
        return Int(size.height * scale)
    }

    func dataRepresentation() -> Data? {
        return UIImagePNGRepresentation(self)
    }
    
    func getReconciledCGImageRef() -> CGImage? {
        return cgImage
    }
    
}

enum PictographEncodingOptions : Int {
    case none = -1
    case unencryptedMessage = 0
    case encryptedMessage  = 1
    case unencryptedImage  = 2
    case unencryptedMessageWithImage = 3
    case encryptedMessageWithImage = 4
}
//extension PictographImage {
//    convenience init(bar :String) {
//        self.init()
//    }
//}
