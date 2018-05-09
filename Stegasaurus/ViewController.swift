//
//  ViewController.swift
//  Stegasaurus
//
//  Created by Elliott Williams on 4/28/18.
//  Copyright © 2018 AgrippaApps. All rights reserved.
//

import UIKit
import ISStego

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {

    var imageToPass = #imageLiteral(resourceName: "Stegasaurus")
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
        if imageToPass != #imageLiteral(resourceName: "Stegasaurus") {
            performSegue(withIdentifier: "toFinished", sender: nil)
        } else {
            print("still equals stegasaurus filler image")
            STEGAlert.displayAlert(title: "Incomplete", message: "Please add an image and a transaction to encode before proceeding.", buttonLabel: "Ok", fromController: self)
        }
        // alert if no image or text
        
    }
    
    
    
    @IBOutlet weak var chooseImageButton: UIButton!
    
    @IBAction func chooseImageButton(_ sender: Any) {
        
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)

        
        
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

    
    
    
    
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let destinationViewController = segue.destination as? FinishedViewController {
            destinationViewController.passedImage = imageToPass
        }

    }

    
    
    

    
    
} // end class













