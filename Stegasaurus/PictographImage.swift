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
    
    func getReconciledImageWidth() -> Int {
        return Int(size.width * scale)
    }
    
    func getReconciledImageHeight() -> Int {
        return Int(size.height * scale)
    }


    
}
//extension PictographImage {
//    convenience init(bar :String) {
//        self.init()
//    }
//}
