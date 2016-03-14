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
    var dataCollector: DataCollector = DataCollector()
    var token: String = "nothing"
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBAction func loginButtonPressed(sender: AnyObject){
        
        //authenticate user
        
        let parameterString = "email=\(emailTextField.text!)&password=\(passwordTextField.text!)"

        dataCollector.loginOrRegistrationRequest(loginUrlString, paramString: parameterString, completionHandler: { (data, errorString) -> Void in
            if let unwrappedErrorString = errorString
            {
                print(unwrappedErrorString)
            }
            else
            {
                self.token = self.dataCollector.token
                print("User Logged in with token \(self.token)")
            }
            
        })
        performSegueWithIdentifier("loginToMyBeerSegue", sender: nil)
    }
    
    @IBAction func registerButtonPressed(sender: AnyObject) {
        //transition to the registration view
        performSegueWithIdentifier("loginToRegisterSegue", sender: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}
