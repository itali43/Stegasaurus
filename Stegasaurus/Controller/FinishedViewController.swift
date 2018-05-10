//
//  FinishedViewController.swift
//  Stegasaurus
//
//  Created by Elliott Williams on 5/2/18.
//  Copyright © 2018 AgrippaApps. All rights reserved.
//

import UIKit
import ISStego
import Foundation
import Security
import PromiseKit


class FinishedViewController: UIViewController {
    // image and transaction injection from previous VC
    var passedTXN = "---------"
    var passedImage: UIImage = #imageLiteral(resourceName: "Stegasaurus")
    
    // loading screen
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var loadingStega: UIImageView!
    
    
    
    
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
//        print(createAlphaNumericRandomString(length: 337))

            let vc = UIActivityViewController(activityItems: [passedImage], applicationActivities: [])
            present(vc, animated: true)

    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        rotationAnimation(buttonToRotate: )
        
        
        
        
        let stegaImage = UIImageView(image: #imageLiteral(resourceName: "albinoStegasaurus"))
        stegaImage.contentMode = .scaleAspectFit
        self.navigationItem.titleView = stegaImage
        finishedImage.image = passedImage
        finishedImage.contentMode = .scaleAspectFit
        finishedImage.image = passedImage
        
        // two red herrings and a big fat secret message
        encryptTransaction(txn: createAlphaNumericRandomString(length: 337)!, into: self.passedImage) { (k) in
            print(k)
            self.encryptTransaction(txn: self.createAlphaNumericRandomString(length: 337)!, into:  self.passedImage) { (kk) in
                print(kk)
                self.encryptTransaction(txn: "\(self.passedTXN)", into:  self.passedImage) { (kkk) in
                    print(kkk)
                    DispatchQueue.main.async {
                        self.finishedImage.image = self.passedImage//.rotate(radians: CGFloat(twoseventy))
                    }
                }
            }
        }

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

    func encryptTransaction(txn: String, into image: UIImage, andThen:@escaping ((String)->())){
        var encryptedPassword = txn
        ISSteganographer.hideData(encryptedPassword, withImage: image, completionBlock: {(_ image: Any?, _ error: Error?) -> Void in
            if error != nil {
                if let anError = error {
                    print("error: \(anError)")
                }
            } else {
                self.passedImage =  UIImage(data: UIImagePNGRepresentation(image as! UIImage)!)!
                print("changed image")
                andThen("done")
                
            }
        })
    }
  
    
    // Random Red Herring Data
    //alternative option
//    func randomString(length: Int) -> String {
//
//        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
//        let len = UInt32(letters.length)
//
//        var randomString = ""
//
//        for _ in 0 ..< length {
//            let rand = arc4random_uniform(len)
//            var nextChar = letters.character(at: Int(rand))
//            randomString += NSString(characters: &nextChar, length: 1) as String
//        }
//
//        return randomString
//    }

    
    
    // creates random strings to encode
    // IMPROVEMENT: may want random data to be the same length as the real transaction || plus or minus a few char
     func createAlphaNumericRandomString(length: Int) -> String? {
        // create random numbers from 0 to 63
        // use random numbers as index for accessing characters from the symbols string
        // this limit is chosen because it is close to the number of possible symbols A-Z, a-z, 0-9
        // so the error rate for invalid indices is low
        let randomNumberModulo: UInt8 = 64
        // indices greater than the length of the symbols string are invalid
        // invalid indices are skipped
        let symbols = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
        var alphaNumericRandomString = ""
        let maximumIndex = symbols.count - 1
        while alphaNumericRandomString.count != length {
            let bytesCount = 1
            var randomByte: UInt8 = 0
            guard errSecSuccess == SecRandomCopyBytes(kSecRandomDefault, bytesCount, &randomByte) else { return nil }
            let randomIndex = randomByte % randomNumberModulo
            // check if index exceeds symbols string length, then skip
            guard randomIndex <= maximumIndex else { continue }
            let symbolIndex = symbols.index(symbols.startIndex, offsetBy: Int(randomIndex))
            alphaNumericRandomString.append(symbols[symbolIndex])
        }
        return alphaNumericRandomString
    }

    
    // loading Animation (spinning stega!)
     func rotationAnimation(buttonToRotate: UIImage) {
        //        refreshOutlet.transform = CGAffineTransform(rotationAngle: (2*CGFloat.pi))
        UIView.animate(withDuration: 0.5) { () -> Void in
            buttonToRotate.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
        }
        UIView.animate(withDuration: 0.5, delay: 0.3, animations: { () -> Void in
            buttonToRotate.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi * 2))
        }, completion: nil)
        print("rotate, hopefully a dinosaur")
    }

} // end class
