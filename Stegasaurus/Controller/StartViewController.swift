//
//  StartViewController.swift
//  Stegasaurus
//
//  Created by Elliott Williams on 5/2/18.
//  Copyright © 2018 AgrippaApps. All rights reserved.
//

import UIKit

enum StateOfStega {
    case hide
    case reveal
}
class StartViewController: UIViewController {

    var stegaPink = UIColor(red: 255/255, green: 0/255, blue: 155/255, alpha: 1.0)
    var darkGrey = UIColor.darkGray
    var stateOfSt: StateOfStega = .hide {
        didSet { //called when item changes
            print("changed state to: \(stateOfSt)")
            changeStateTo(to: stateOfSt)
        }
    }

    @IBOutlet weak var proceedButton: UIButton!
    @IBAction func proceedAction(_ sender: Any) {
        
        if stateOfSt == .hide {
        performSegue(withIdentifier: "toHide", sender: nil)
        } else {
            performSegue(withIdentifier: "toReveal", sender: nil)
        }
    }
    
    
    
    
    
    @IBOutlet weak var stegaImage: UIImageView!
    @IBOutlet weak var textView: UITextView!
    
    // hide or reveal switcher
    @IBOutlet weak var hideBTN: UIButton!
    @IBAction func hideAction(_ sender: Any) {
        stateOfSt = .hide
    }
    @IBOutlet weak var revealBTN: UIButton!
    @IBAction func revealAction(_ sender: Any) {
        stateOfSt = .reveal
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func changeStateTo(to: StateOfStega) {
        if to == .hide {
            // hide pressed
            hideBTN.backgroundColor = stegaPink
            hideBTN.setTitleColor(.white, for: .normal)


            revealBTN.backgroundColor = .lightGray
            revealBTN.setTitleColor(darkGrey, for: .normal)

        } else {
            // reveal pressed
            hideBTN.backgroundColor = .lightGray
            hideBTN.setTitleColor(darkGrey, for: .normal)

            revealBTN.backgroundColor = stegaPink
            revealBTN.setTitleColor(.white, for: .normal)


        }
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
