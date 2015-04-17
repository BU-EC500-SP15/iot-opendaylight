//
//  LoginViewController.swift
//  Compass
//
//  Created by Mark on 2/22/15.
//  Copyright (c) 2015 MEB. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: Outlets
    @IBOutlet var usernameTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!

    @IBOutlet var signupTriangle: UIImageView!
    @IBOutlet var loginTriangle: UIImageView!
    
    @IBOutlet var arrowButton: UIButton!
    
    // MARK: Variables
    var signUpActive = true
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    // MARK: View Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set delegates
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        
        // setup ui
        loginTriangle.alpha = 0
        arrowButton.userInteractionEnabled = false
        arrowButton.alpha = 0
        self.makeUsernameBorder()
        self.makePasswordBorder()
    }
    
    override func viewDidAppear(animated: Bool) {
        // get current user cached on disk
        var currentUser = PFUser.currentUser()
        if currentUser != nil {
            // go to table segue
            self.performSegueWithIdentifier("showMapView", sender: self)
        } else {
            // wait for signup/login
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool)
    {
        // hide nar bar
        self.navigationController?.navigationBarHidden = true
    }
    
    override func viewWillDisappear(animated: Bool)
    {
        // show nav bar
        self.navigationController?.navigationBarHidden = false
    }
    
    // MARK: Actions
    
    @IBAction func signupButtonToggled(sender: AnyObject) {
        if (signUpActive == false) {
            // disable signup mode
            signUpActive = true
            
            // change ui
            signupTriangle.alpha = 1
            loginTriangle.alpha = 0
        }
    }
    
    @IBAction func loginButtonToggled(sender: AnyObject) {
        if (signUpActive == true) {
            // disable signup mode
            signUpActive = false
            
            // change ui
            signupTriangle.alpha = 0
            loginTriangle.alpha = 1
        }
    }
    
    @IBAction func arrowButtonSelected(sender: AnyObject) {
        // init error string
        var error = "";
        
        // check for empty email or password text fields
        if (usernameTextField.text == "" || passwordTextField.text == "") {
            error = "Please enter a email and password"
        }
            
        // check for minimum / maximum username string length
        else if (count(usernameTextField.text) >= 11 || count(usernameTextField.text) <= 2) {
            error = "Invalid username length. Must be 3 - 10 characters"
        }
        
        // check for minimum / maximum password string length
        else if (count(passwordTextField.text) >= 21 || count(passwordTextField.text) <= 3) {
            error = "Invalid password length. Must be 4 - 20 characters"
        }
        
        // if the error string is not empty
        if (error != "") {
            self.displayAlert("Error", error: error)
        }
            
        else {
            // create a new PFUser
            var user = PFUser()
            
            // set the user's name and password
            user.username = usernameTextField.text
            user.password = passwordTextField.text
            
            // inital activity indicator setup
            activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0.0, 0.0, 100, 100))
            activityIndicator.center = self.view.center
            activityIndicator.hidesWhenStopped = true;
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
            
            // add to view and start animation
            view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            
            // begin ignoring user interaction
            UIApplication.sharedApplication().beginIgnoringInteractionEvents()
            
            // check if sign up is active
            if (signUpActive == true) {
                // sign up in background
                user.signUpInBackgroundWithBlock {
                    (succeeded: Bool, signupError: NSError!) -> Void in
                    if signupError == nil {
                        
                        // stop animation and end ignoring events
                        self.activityIndicator.stopAnimating()
                        UIApplication.sharedApplication().endIgnoringInteractionEvents()
                        
                        // now user can use app
                        NSLog("Signed Up.")
                        
                        // initializes all required containers for new user
                        MBSwiftPostman().createNewUserContainer()
                        
                        // go to table segue
                        self.performSegueWithIdentifier("showMapView", sender: self)
                        
                    } else {
                        
                        // stop animation and end ignoring events
                        self.activityIndicator.stopAnimating()
                        UIApplication.sharedApplication().endIgnoringInteractionEvents()
                        
                        // might be an error to display
                        if let errorString = signupError.userInfo?["error"] as? NSString {
                            error = errorString as String
                        } else {
                            error = "Oops. Something went wrong."
                        }
                        
                        self.displayAlert("Could Not Sign Up", error: error)
                    }
                }
            }
                // if login is active
            else if (signUpActive == false) {
                
                PFUser.logInWithUsernameInBackground(usernameTextField.text, password:passwordTextField.text) {
                    (user: PFUser!, loginError: NSError!) -> Void in
                    if loginError == nil {
                        
                        // stop animation and end ignoring events
                        self.activityIndicator.stopAnimating()
                        UIApplication.sharedApplication().endIgnoringInteractionEvents()
                        
                        // perform user table segue
                        self.performSegueWithIdentifier("showMapView", sender: self)
                        
                        NSLog("Logged In.")
                        
                    } else {
                        
                        // stop animation and end ignoring events
                        self.activityIndicator.stopAnimating()
                        UIApplication.sharedApplication().endIgnoringInteractionEvents()
                        
                        // might be an error to display
                        if let errorString = loginError.userInfo?["error"] as? NSString {
                            error = errorString as String
                        } else {
                            error = "Oops. Something went wrong."
                        }
                        
                        self.displayAlert("Invalid Login", error: error)
                    }
                }
            }
        }
    }
    
    // MARK: Utility Methods
    
    func makeUsernameBorder() {
        var eborder = CALayer()
        var width = CGFloat(0.3)
        eborder.borderColor = UIColor.lightGrayColor().CGColor
        eborder.frame = CGRect(x: 0, y: usernameTextField.frame.size.height - width, width:  usernameTextField.frame.size.width, height: usernameTextField.frame.size.height)
        eborder.borderWidth = width
        usernameTextField.layer.addSublayer(eborder)
    }
    
    func makePasswordBorder() {
        var pborder = CALayer()
        var width = CGFloat(0.3)
        pborder.borderColor = UIColor.lightGrayColor().CGColor
        pborder.frame = CGRect(x: 0, y: passwordTextField.frame.size.height - width, width:  passwordTextField.frame.size.width, height: passwordTextField.frame.size.height)
        pborder.borderWidth = width
        passwordTextField.layer.addSublayer(pborder)
    }
    
    // MARK: Text Field Functions
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        // end editing when touching view
        self.view.endEditing(true)
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        // show buttons
        arrowButton.userInteractionEnabled = true
        arrowButton.alpha = 1
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        
        if usernameTextField.text == "" || passwordTextField.text == "" {
            // hide buttons
            arrowButton.userInteractionEnabled = false
            arrowButton.alpha = 0
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        usernameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        return true
    }
    
    // MARK: Alert Functions
    
    func displayAlert(title:String, error:String) {
        // display error alert
        var errortAlert = UIAlertController(title: title, message: error, preferredStyle: UIAlertControllerStyle.Alert)
        errortAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { action in
            // close alert
        }))
        
        self.presentViewController(errortAlert, animated: true, completion: nil)
    }
}
