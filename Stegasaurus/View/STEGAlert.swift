//
//  PSAlert.swift
//  PurpleSwan
//
//  Created by Elliott Williams on 1/20/18.
//  Copyright © 2018 AgrippaApps. All rights reserved.
//

import Foundation
import UIKit

enum CameraChoice {
    case photoLibrary
    case camera
    case cancel
}

struct STEGAlert {
    static func displayAlert(title: String, message: String, buttonLabel: String, fromController: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: buttonLabel, style: UIAlertActionStyle.default, handler: nil))
        fromController.present(alert, animated: true, completion: nil)
    }
    
    static func cameraOrLibrary(fromVC: UIViewController, andThen:@escaping ((CameraChoice)->())) {
        let alertController = UIAlertController(title: "New or Old", message: "Would you like to take a new photo or use one previously taken?", preferredStyle: .actionSheet)
        let cameraButton = UIAlertAction(title: "Camera", style: .default, handler: { (action) -> Void in
            print("camera button tapped")
            andThen(CameraChoice.camera)
        })
        let  photoLibButton = UIAlertAction(title: "Photo Library", style: .default, handler: { (action) -> Void in
            print("photo lib button tapped")
            andThen(CameraChoice.photoLibrary)
        })
        let cancelButton = UIAlertAction(title: "Nevermind", style: .cancel, handler: { (action) -> Void in
            print("nevermind button tapped")
            andThen(CameraChoice.cancel)
        })
        alertController.addAction(cameraButton)
        alertController.addAction(photoLibButton)
        alertController.addAction(cancelButton)
        fromVC.navigationController!.present(alertController, animated: true, completion: nil)
        
    }
    
    
    
    
    
    
    
    
//    static func displayExecuteAlert(title: String, message: String, proceedButton: String, fromController: UIViewController, handle: @escaping ((Bool)->())) {
//        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
//        alert.addAction(UIAlertAction(title: proceedButton, style: UIAlertActionStyle.default, handler: { (alert: UIAlertAction!) in
//            print("Execute Order")
//            handle(true)
//        }))
//        alert.addAction(UIAlertAction(title: "Nevermind", style: UIAlertActionStyle.default, handler: { (alert: UIAlertAction!) in
//            print("Do Not Execute")
//            handle(false)
//        }))
//        fromController.present(alert, animated: true, completion: nil)
//
//    }
//    // end execution alert
//
//
//    static func passwordProtection(message: String, fromController: UIViewController, handle: @escaping ((Bool)->())) {
//        let alert = UIAlertController(title: "Password Protected", message: message, preferredStyle: UIAlertControllerStyle.alert)
//
//        alert.addTextField { (textField) in
//            textField.placeholder = "Password"
//            textField.isSecureTextEntry = true
//        }
//
//        alert.addAction(UIAlertAction(title: "Proceed", style: UIAlertActionStyle.default, handler: {  [weak alert] (_) in
//            let textField = alert!.textFields![0] // Force unwrapping because we know it exists.
//            print("Text field: \(textField.text!)")
//            PSAuth.passwordProtected(passwordGiven: textField.text!, handle: { (matched) in
//                if matched == true {
//                    handle(true)
//                } else {
//                    handle(false)
//                }
//
//            })
//
//        }))
//        alert.addAction(UIAlertAction(title: "Nevermind", style: UIAlertActionStyle.default, handler: { (alert: UIAlertAction!) in
//            print("Do Not Execute")
//
//        }))
//        fromController.present(alert, animated: true, completion: nil)
//    }
//
    static func twoOptionButton(title: String, message: String, btn1: String, btn2: String, fromController: UIViewController, pressedLeftBTN: @escaping ((Bool)->())) {
        // set up alert
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        // add first button
        alert.addAction(UIAlertAction(title: btn1, style: UIAlertActionStyle.default, handler: {  [weak alert] (_) in
            print("btn1 (true) pressed")
            pressedLeftBTN(true)
        }))
        // add second button
        alert.addAction(UIAlertAction(title: btn2, style: UIAlertActionStyle.default, handler: { (alert: UIAlertAction!) in
            print("btn2 (false) pressed")
            pressedLeftBTN(false)
        }))
        fromController.present(alert, animated: true, completion: nil)
    }
}

