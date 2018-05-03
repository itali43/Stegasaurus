//
//  ViewController.swift
//  Stegasaurus
//
//  Created by Elliott Williams on 4/28/18.
//  Copyright © 2018 AgrippaApps. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {

    @IBOutlet weak var imageView: UIImageView!
    let imagePicker = UIImagePickerController()
    
    @IBOutlet weak var doneButton: UIButton!
    
    @IBAction func doneAction(_ sender: Any) {
        performSegue(withIdentifier: "toFinished", sender: nil)
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

    
    // camera + photo library
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        print("cancelled picker")
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        print("finished with picker")

        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            print("sent back image from picker")
            imageView.contentMode = .scaleAspectFit
            imageView.image = pickedImage
        }
        
        dismiss(animated: true, completion: nil)
    }

}

