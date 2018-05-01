//
//  FirstViewController.swift
//  WitnessChainPolice
//
//  Created by Dhruv Gupta on 4/13/18.
//  Copyright © 2018 Dhruv Gupta. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuthUI

class SettingsViewController: UIViewController {
    
    let user = Auth.auth().currentUser
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func logout(sender: Any?){
        do {
            try Auth.auth().signOut()
            performSegue(withIdentifier: "settingssignout", sender: nil)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }

}

