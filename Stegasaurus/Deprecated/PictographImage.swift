//
//  PictographImage.swift
//  Stegasaurus
//
//  Created by Elliott Williams on 5/7/18.
//  Copyright © 2018 AgrippaApps. All rights reserved.
//

import Foundation
import UIKit
import CoreGraphics

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
    
    

    
    
    func scaledImage(withNewSize newSize: CGSize) -> PictographImage? {
        let cgImage = self.cgImage
        let bitsPerComponent: size_t = cgImage!.bitsPerComponent
        let bytesPerRow: size_t = cgImage!.bytesPerRow
        let colorRef = cgImage!.colorSpace
        let bitmapInfo: CGBitmapInfo = cgImage!.bitmapInfo
        let context = CGContext(data: nil, width: Int(newSize.width), height: Int(newSize.height), bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: colorRef!, bitmapInfo: bitmapInfo.rawValue)
//        CGContextSetInterpolationQuality(context!, .high)
        context!.interpolationQuality = .high
//        context.draw(in: cgImage, image: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        context?.draw(cgImage!, in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let image = UIImage(cgImage: (context?.makeImage())!)
        
        return image as? PictographImage
    }
    
    
    
//    func rotatedUIImage(from image: UIImage?) -> UIImage? {
//        let imageWidth: Int? = image?.getReconciledImageWidth()
//        let imageHeight: Int? = image?.getReconciledImageHeight()
//        UIGraphicsBeginImageContext(CGSize(width: CGFloat(imageWidth ?? 0.0), height: CGFloat(imageHeight ?? 0.0)))
//        image?.draw(at: CGPoint(x: 0, y: 0))
//        return UIGraphicsGetImageFromCurrentImageContext()
//    }

    
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
