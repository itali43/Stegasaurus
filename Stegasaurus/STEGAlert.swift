//
//  PSAlert.swift
//  PurpleSwan
//
//  Created by Elliott Williams on 1/20/18.
//  Copyright © 2018 AgrippaApps. All rights reserved.
//

import Foundation
import UIKit

struct STEGAlert {
    static func displayAlert(title: String, message: String, buttonLabel: String, fromController: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: buttonLabel, style: UIAlertActionStyle.default, handler: nil))
        fromController.present(alert, animated: true, completion: nil)
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
//    static func adminPasswordProtection(message: String, fromController: UIViewController, handle: @escaping ((Bool)->())) {
//        let alert = UIAlertController(title: "Admin Password Required", message: message, preferredStyle: UIAlertControllerStyle.alert)
//
//        alert.addTextField { (textField) in
//            textField.placeholder = "Password"
//            textField.isSecureTextEntry = true
//        }
//
//        alert.addAction(UIAlertAction(title: "Enter", style: UIAlertActionStyle.default, handler: {  [weak alert] (_) in
//            let textField = alert!.textFields![0] // Force unwrapping because we know it exists.
//            print("Text field: \(textField.text!)")
//            if textField.text! == "sowhenmoon" {
//                handle(true)
//            } else {
//                handle(false)
//            }
//        }))
//        alert.addAction(UIAlertAction(title: "Nevermind", style: UIAlertActionStyle.default, handler: { (alert: UIAlertAction!) in
//            print("Do Not Execute")
//
//        }))
//        fromController.present(alert, animated: true, completion: nil)
//    }
}

