//
//  LoginViewController.swift
//  MyBrew
//
//  Created by Jayme Becker on 1/31/16.
//  Copyright © 2016 Jayme Becker. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBAction func loginButtonPressed(sender: AnyObject){
        
        //authenticate user
        print("User Logged in")
        
        performSegueWithIdentifier("loginToMyBeerSeque", sender: nil)
    }
    
    @IBAction func signUpButtonPressed(sender: AnyObject) {
        
        print("Sign up")
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
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}
