//
//  MBNavigationViewController.swift
//  Compass
//
//  Created by Mark on 3/31/15.
//  Copyright (c) 2015 MEB. All rights reserved.
//

import UIKit

class MBNavigationViewController: UINavigationController, UIViewControllerTransitioningDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Customize nav bar
        self.navigationBar.barStyle = UIBarStyle.Black // makes status bar text white
        self.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationBar.barTintColor = UIColorFromHex(0x01caa0, alpha: 1.0)
        self.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
    }
    
    // MARK: Utility Methods
    
    func UIColorFromHex(rgbValue:UInt32, alpha:Double=1.0)->UIColor {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
    }
}
