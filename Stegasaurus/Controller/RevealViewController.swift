//
//  RevealViewController.swift
//  Stegasaurus  
//
//  Created by Elliott Williams on 5/8/18.
//  Copyright © 2018 AgrippaApps. All rights reserved.
//

import UIKit
import Foundation
import ISStego

class RevealViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var revealImage: UIImageView!
    var stegaRevealUIImage = #imageLiteral(resourceName: "Stegasaurus")  {
        didSet { //called when item changes
            print("changed state image")
            decryptTransaction(from: stegaRevealUIImage)
        }
    }


    let imagePicker = UIImagePickerController()
    var txnToCopy = ""
    @IBOutlet weak var txnTV: UITextView!
    
    @IBOutlet weak var chooseImageBTN: UIButton!
    @IBAction func chooseImageAction(_ sender: Any) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)

    }
    
    @IBOutlet weak var copyTXNBTN: UIButton!
    @IBAction func copyTXNAction(_ sender: Any) {
// copy TXN to clipboard
//        if let finishedImaged = finishedImage.image {
            print("transaction copied to clipboard")
            UIPasteboard.general.string = txnToCopy
//        }

    }
    
    @IBOutlet weak var sendTXNBTN: UIButton!
    @IBAction func sendTXNAction(_ sender: Any) {
        // activity monitor
        let vc = UIActivityViewController(activityItems: [txnToCopy], applicationActivities: [])
        if let popoverController = vc.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }

        present(vc, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        txnTV.isUserInteractionEnabled = false
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
            stegaRevealUIImage = pickedImage
            revealImage.image = stegaRevealUIImage
//            decryptTransaction(from: stegaRevealUIImage)
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    

    ///        decryptTransaction(from: finishedImage.image!)
    func decryptTransaction(from image: UIImage) {
        //        var image = UIImage(named: "stegoImageName")
        self.txnTV.text = "Decrypting..."

        print("decrypting...")
        ISSteganographer.data(fromImage: image, completionBlock: {(_ data: Data?, _ error: Error?) -> Void in
            print("decrypting... ........")

            if error != nil {
                if let anError = error {
                    print("error: \(anError)")
                }
            } else {
                print("decrypting...more")

                var hiddenData: String? = "Error: Doesn't seem to be a message in this image.  If you think there is, try again."
                if let aData = data {
                    hiddenData = String(data: aData, encoding: .utf8)
                    print("decrypting...hiddenData")

                }
                print("hidden string: \(hiddenData ?? "")")
                
                DispatchQueue.main.async {
                    self.txnTV.text = "\(hiddenData ?? "Error: Doesn't seem to be a message in this image.  If you think there is, try again.")"
                    self.self.txnToCopy = "\(hiddenData ?? "Error: Doesn't seem to be a message in this image.  If you think there is, try again.")"
                }
            }
            print("decrypting... outta closure")

        })
        
    }
}
