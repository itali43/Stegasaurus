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
//import PromiseKit
import RNCryptor
import MessageUI



class FinishedViewController: UIViewController, MFMailComposeViewControllerDelegate, UINavigationControllerDelegate {
    // image and transaction injection from previous VC
    var passedTXN = "---------"
    var passedImage: UIImage = #imageLiteral(resourceName: "Stegasaurus")

    // loading screen
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var loadingStega: UIButton!
    
    @IBAction func loadingStegaAction(_ sender: Any) {
        print("load that stega!")
    }
    
    
    
    @IBOutlet weak var finishedImage: UIImageView!
    
    @IBOutlet weak var copyBTN: UIButton!
    @IBAction func copyAction(_ sender: Any) {

        if let finishedImaged = finishedImage.image {
            print("image copied to clipboard, show alert")
            UIPasteboard.general.image = finishedImage.image
        }
    }
    
    
    @IBOutlet weak var finishedText: UILabel!
    
    // mail controller ends
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        print("Finished composing, mail controller should be disappearing")
        switch result {
        case .cancelled:
            print("Mail cancelled")
        case .saved:
            print("Mail saved")
        case .sent:
            print("Mail sent")
        case .failed:
            print("Mail sent failure: %@", [error?.localizedDescription])
        default:
            break
        }
        self.dismiss(animated: true, completion: nil)

//        controller.dismiss(animated: true, completion: nil)
    }

    
    
    func composeMail() {
        // have to create a new one every time ;)
        let mailComposeVC = MFMailComposeViewController()
        mailComposeVC.delegate = self
        mailComposeVC.mailComposeDelegate = self

        mailComposeVC.delegate = self
        mailComposeVC.mailComposeDelegate = self

        print("compose!")
            mailComposeVC.addAttachmentData(UIImagePNGRepresentation(passedImage)!, mimeType: "image/png", fileName:  "image1.jpeg")
            mailComposeVC.setSubject("Check this out!")
            
        mailComposeVC.setMessageBody("<html><body><p>Check out this picture: there's something hidden in it! </p>   <p>Get in the know, join Club Stegasaurus: http://new.stegasaurus.com</p></body></html>", isHTML: true)
            
            present(mailComposeVC, animated: true, completion: nil)

        
    } // end compose mail

    
    @IBOutlet weak var sendBTN: UIButton!
    @IBAction func sendAction(_ sender: Any) {
//        print(createAlphaNumericRandomString(length: 337))
        STEGAlert.displayAlertWithCompletion(title: "ACTUAL SIZE", message: "For now, you must set image to ACTUAL SIZE or the image will not send.  /n -StegaTeam", buttonLabel: "ACTUAL SIZE it is!", fromController: self) {
            print("after the alert has gone")
            self.composeMail()
        }
        
        // activity controller send in any fashion
//            let vc = UIActivityViewController(activityItems: [passedImage], applicationActivities: [])
//        if let popoverController = vc.popoverPresentationController {
//            popoverController.sourceView = self.view
//            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
//            popoverController.permittedArrowDirections = []
//        }
//
//            present(vc, animated: true)

    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

//        print("OK..")
//        var encr =   encrypt(this: "Look at me!", with: "passthis")
//        print("ENCRY", encr)
//        var decry = decrypt(this: encr, with: "passthis")
//        print("DDDD", decry)
//        print("OK..")
//        rotationAnimation(buttonToRotate: loadingStega)
        loadingStega.startRotating(duration: CFTimeInterval(2), repeatCount: .infinity, clockwise: true)

        // add image to title in navigation bar
        let stegaImage = UIImageView(image: #imageLiteral(resourceName: "albinoStegasaurus"))
        stegaImage.contentMode = .scaleAspectFit
        self.navigationItem.titleView = stegaImage
//        finishedImage.image = passedImage
//        finishedImage.contentMode = .scaleAspectFit
//        finishedImage.image = passedImage
        
        // two red herrings and a big fat secret message
        encryptTransaction(txn: createAlphaNumericRandomString(length: 337)!, into: self.passedImage) { (k) in
            print(k)
            self.encryptTransaction(txn: self.createAlphaNumericRandomString(length: 337)!, into:  self.passedImage) { (kk) in
                print(kk)
                self.encryptTransaction(txn: "\(self.passedTXN)", into:  self.passedImage) { (kkk) in
                    print("actually ", kkk)
                    print("image occidentation before", self.passedImage.imageOrientation)
                    self.passedImage = self.passedImage.upOrientationImage()!
                    print("image occidentation after", self.passedImage.imageOrientation)

                    DispatchQueue.main.async {
                        self.finishedImage.image = self.passedImage//.rotate(radians: CGFloat(twoseventy))
                        self.loadingView.isHidden = true
                        self.loadingStega.stopRotating()
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
    
    // Passworded Encryption  ==============================

    func encrypt(this: String, with password: String) -> String {
        // Encryption
        let data: Data? = this.data(using: .utf8)  // non-nil
//        let data: NSData = NSData(
        let ciphertext = RNCryptor.encrypt(data: data!, withPassword: password) // needs error coverage
        print(ciphertext)
        var stringCiph = String(data: ciphertext, encoding: .utf8)
        print(stringCiph)
        return stringCiph ?? "nope"
    }
    
    func decrypt(this: String, with password: String) {
        // Decryption
        do {
            let dataFromString = this.data(using: .utf8)
            let originalData = try RNCryptor.decrypt(data: dataFromString!, withPassword: password)
        // ...
        } catch {
            print(error)
        }

    }
    
    
    
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
                let theImage = UIImage(data: UIImagePNGRepresentation(image as! UIImage)!)!
//                let jpgTHEIMAGE = UIImage(data: UIImageJPEGRepresentation(theImage, 0.1)!)!

                self.passedImage =  theImage
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

    //for keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        // This function makes it so that if you tap outside of the keyboard it will disappear.
    }

    
    
    
    // loading Animation (spinning stega!)
//     func rotationAnimation(buttonToRotate: UIButton) {
//        //        refreshOutlet.transform = CGAffineTransform(rotationAngle: (2*CGFloat.pi))
//
//        UIView.animate(withDuration: 0.5) { () -> Void in
//            buttonToRotate.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
//        }
//        UIView.animate(withDuration: 0.5, delay: 0.3, animations: { () -> Void in
//            buttonToRotate.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi * 2))
//        }, completion: nil)
//
//
//        print("rotate, hopefully a dinosaur")
//    }

} // end class
