//
//  LoginViewController.swift
//  MyBrew
//
//  Created by Jayme Becker on 1/31/16.
//  Copyright © 2016 Jayme Becker. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    let loginUrlString = "https://api-mybrew.rhcloud.com/api/auth/login"
    var dataCollector : DataCollector = DataCollector()
    var status : String?
    var message : String?

    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBAction func loginButtonPressed(sender: AnyObject){
        
        //authenticate user
        let parameterString = "email=\(emailTextField.text!)&password=\(passwordTextField.text!)"

        //call the loginOrRegistrationRequest method to parse the login request
        dataCollector.loginOrRegistrationRequest(loginUrlString, paramString: parameterString, completionHandler: { (status, errorString) -> Void in
            if let unwrappedErrorString = errorString
            {
                print(unwrappedErrorString)
            }
            else
            {
                //save the status and message returned
                self.status = status
               // self.message = message
                print("User Logged in with token \(DataCollector.token)")
                self.transitionToMyBeerView()
            }
        }
        
        )
    }
    
    @IBAction func registerButtonPressed(sender: AnyObject) {
        //transition to the registration view
        performSegueWithIdentifier("loginToRegisterSegue", sender: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func transitionToMyBeerView()
    {
        //check the login status
        if(status == "ok")
        {
            performSegueWithIdentifier("loginToMyBeerSegue", sender: nil)
        }
        else
        {
            let alertController = UIAlertController(title: "Login Failed", message: "Username or password Invalid", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
            
            self.presentViewController(alertController, animated: true, completion: nil)
            
        }
    }

    
    // MARK: - Navigation

//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        // Get the new view controller using segue.destinationViewController.
//        // Pass the selected object to the new view controller.
//        let destinationViewController = segue.destinationViewController as! MyBeerTableViewController
//        destinationViewController.token = self.token
//        
//    }
    
}
