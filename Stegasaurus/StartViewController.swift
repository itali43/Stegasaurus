//
//  StartViewController.swift
//  Stegasaurus
//
//  Created by Elliott Williams on 5/2/18.
//  Copyright © 2018 AgrippaApps. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {

    @IBOutlet weak var proceedButton: UIButton!
    @IBAction func proceedAction(_ sender: Any) {
        
        performSegue(withIdentifier: "toMain", sender: nil)
    }
    
    
    
    
    
    @IBOutlet weak var stegaImage: UIImageView!
    @IBOutlet weak var textView: UITextView!
    
    // hide or reveal switcher
    @IBOutlet weak var hideBTN: UIButton!
    @IBAction func hideAction(_ sender: Any) {
    }
    @IBOutlet weak var revealBTN: UIButton!
    @IBAction func revealAction(_ sender: Any) {
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

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

}
