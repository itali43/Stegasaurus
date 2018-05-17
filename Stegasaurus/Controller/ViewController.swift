//
//  ViewController.swift
//  Stegasaurus
//
//  Created by Elliott Williams on 4/28/18.
//  Copyright © 2018 AgrippaApps. All rights reserved.
//

import UIKit
import ISStego

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate,  UITextFieldDelegate {
    
    var imageToPass = #imageLiteral(resourceName: "Stegasaurus")
    var messageToPass = ""
    @IBAction func updateMessageFromTF(_ sender: Any) {
        messageToPass = txnTF.text!
        print("--\(messageToPass)--")
    }
    
    
    
    //?work?
    // This function makes the return button make the keyboard disappear
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            self.view.endEditing(true)
            return true
        }

    @IBOutlet weak var txnTF: UITextField!
    
    @IBOutlet weak var pasteBTN: UIButton!
    
    @IBAction func pasteAction(_ sender: Any) {
        if let pasteString = UIPasteboard.general.string {
            txnTF.text = pasteString
        }

    }
    

    
    @IBOutlet weak var imageView: UIImageView!
    let imagePicker = UIImagePickerController()
    
    @IBOutlet weak var doneButton: UIButton!
    
    @IBAction func doneAction(_ sender: Any) {
        if imageToPass != #imageLiteral(resourceName: "Stegasaurus") && txnTF.text != "" {
            performSegue(withIdentifier: "toFinished", sender: nil)
        } else {
            print("still equals stegasaurus filler image")
            STEGAlert.displayAlert(title: "Incomplete", message: "Please add an image and a transaction to encode before proceeding.", buttonLabel: "Ok", fromController: self)
        }
        // alert if no image or text
        
    }
    
    
    
    @IBOutlet weak var chooseImageButton: UIButton!
    
    @IBAction func chooseImageButton(_ sender: Any) {
        


        STEGAlert.cameraOrLibrary(fromVC: self) { (choiceOfCamera) in
            switch choiceOfCamera {
                case .camera:
                    print("camera")
                    self.imagePicker.allowsEditing = false
                    self.self.imagePicker.sourceType = .camera
                    self.present(self.imagePicker, animated: true, completion: nil)
                case .photoLibrary:
                    print("PL")
                    self.photoLibAction()
                case .cancel:
                    print("cancel action sheet")
                default:
                print("defaulted, so just cancel action sheet anyway")
            }
        }
        
        
        
        
        


        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        

    } // end viewdidload

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

        //for keyboard
        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            self.view.endEditing(true)
            // This function makes it so that if you tap outside of the keyboard it will disappear.
        }

    // camera + photo library
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("cancelled picker")
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print("finished with picker")

        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            print("sent back image from picker")
            imageView.contentMode = .scaleAspectFit
            imageView.image = pickedImage
            imageToPass = pickedImage
        }
        
        dismiss(animated: true, completion: nil)
    }

    
    // photo library warning
    func photoLibAction() {
        STEGAlert.twoOptionButton(title: "Security Best Practices", message: "We'd like to note it's best to take a picture or use a picture you've taken before.  It is less conspicuous and the randomness of the pixels is positive for the obscurity at the heart of Steganography.  \n It is also recommended to use different pictures each time.", btn1: "You aren't my Nanny! Onward!", btn2: "Nevermind, I'll take a pic", fromController: self) { (onwardPressed) in
        
        print("onward pressed", onwardPressed)
        if onwardPressed == true {
            //photo library work
            self.imagePicker.allowsEditing = false
            self.imagePicker.sourceType = .photoLibrary
            self.present(self.imagePicker, animated: true, completion: nil)
        } else {
            print("camera")
            self.imagePicker.allowsEditing = false
            self.self.imagePicker.sourceType = .camera
            self.present(self.imagePicker, animated: true, completion: nil)
        }
        }
    
    } // end photolib function
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let destinationViewController = segue.destination as? FinishedViewController {
            let newImage = rotateImage(image: imageToPass)
            destinationViewController.passedImage = newImage
            destinationViewController.passedTXN = messageToPass
        }

    }

    func rotateImage(image: UIImage) -> UIImage {
        
        if (image.imageOrientation == UIImageOrientation.up ) {
            return image
        }
        
        UIGraphicsBeginImageContext(image.size)
        
        image.draw(in: CGRect(origin: CGPoint.zero, size: image.size))
        let copy = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return copy!
    }

    
    

    
    
} // end class













