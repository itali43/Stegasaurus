//
//  RevealViewController.swift
//  Stegasaurus
//
//  Created by Elliott Williams on 5/8/18.
//  Copyright © 2018 AgrippaApps. All rights reserved.
//

import UIKit

class RevealViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var revealImage: UIImageView!
    let imagePicker = UIImagePickerController()

    
    @IBOutlet weak var chooseImageBTN: UIButton!
    @IBAction func chooseImageAction(_ sender: Any) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)

    }
    
    @IBOutlet weak var copyTXNBTN: UIButton!
    @IBAction func copyTXNAction(_ sender: Any) {
        
    }
    
    @IBOutlet weak var sendTXNBTN: UIButton!
    @IBAction func sendTXNAction(_ sender: Any) {
        
    }
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
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
            revealImage.contentMode = .scaleAspectFit
            revealImage.image = pickedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    


}
