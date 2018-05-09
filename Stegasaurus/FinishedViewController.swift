//
//  FinishedViewController.swift
//  Stegasaurus
//
//  Created by Elliott Williams on 5/2/18.
//  Copyright © 2018 AgrippaApps. All rights reserved.
//

import UIKit
import ISStego
class FinishedViewController: UIViewController {

    var passedImage: UIImage = #imageLiteral(resourceName: "Stegasaurus")
    @IBOutlet weak var finishedImage: UIImageView!
    
    @IBOutlet weak var copyBTN: UIButton!
    @IBAction func copyAction(_ sender: Any) {
        if let finishedImaged = finishedImage.image {
            print("image copied to clipboard, show alert")
            UIPasteboard.general.image = finishedImage.image
        }
    }
    
    
    @IBOutlet weak var finishedText: UILabel!
    @IBOutlet weak var sendBTN: UIButton!
    @IBAction func sendAction(_ sender: Any) {
        decryptTransaction(from: finishedImage.image!)
//            let vc = UIActivityViewController(activityItems: [passedImage], applicationActivities: [])
//            present(vc, animated: true)

    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let stegaImage = UIImageView(image: #imageLiteral(resourceName: "albinoStegasaurus"))
        stegaImage.contentMode = .scaleAspectFit
        self.navigationItem.titleView = stegaImage
        finishedImage.image = passedImage
        finishedImage.contentMode = .scaleAspectFit
        encryptTransaction(txn: "Elliott is a member of the stegasaurus club", into: passedImage)
        finishedImage.image = passedImage


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
    
    // STEGANOGRAPHY  ==============================
    // STEGANOGRAPHY  ------------------------------------------------------
    // STEGANOGRAPHY  ==============================
    // STEGANOGRAPHY  ------------------------------------------------------
    // STEGANOGRAPHY  ==============================
    //----------------------------------------------------------------------------
    //==========================================
    //----------------------------------------------------------------------------
    //==========================================
    
    func encryptTransaction(txn: String, into image: UIImage) {
        var encryptedPassword = txn
        ISSteganographer.hideData(encryptedPassword, withImage: image, completionBlock: {(_ image: Any?, _ error: Error?) -> Void in
            if error != nil {
                if let anError = error {
                    print("error: \(anError)")
                }
            } else {
                
                DispatchQueue.main.async {
                    self.finishedImage.image = UIImage(data: UIImagePNGRepresentation(image as! UIImage)!)
                    print("changed image")
                }
            }
        })
    }
    
    func decryptTransaction(from image: UIImage) {
        //        var image = UIImage(named: "stegoImageName")
        ISSteganographer.data(fromImage: image, completionBlock: {(_ data: Data?, _ error: Error?) -> Void in
            if error != nil {
                if let anError = error {
                    print("error: \(anError)")
                }
            } else {
                var hiddenData: String? = nil
                if let aData = data {
                    hiddenData = String(data: aData, encoding: .utf8)
                }
                print("hidden string: \(hiddenData ?? "")")
                
                                DispatchQueue.main.async {
                                    self.finishedText.text = "\(hiddenData ?? ":(")"
                                }
            }
        })
        
    }


}
