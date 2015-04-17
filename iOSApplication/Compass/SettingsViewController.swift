//
//  SettingsViewController.swift
//  Compass
//
//  Created by Mark on 4/8/15.
//  Copyright (c) 2015 MEB. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logoutButtonSelected(sender: AnyObject) {
        PFUser.logOut()
        performSegueWithIdentifier("showLoginView", sender: self)
    }

}
