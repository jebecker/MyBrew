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
    
    @IBAction func tapToDismissKeyboard(_ sender: AnyObject) {
        self.view.endEditing(true)
    }
    @IBAction func loginButtonPressed(_ sender: AnyObject){
        
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
                    print("User Logged in with token \(DataCollector.token!)")
                    self.transitionToMyBeerView()
                }
            }
        )
    }
    
    @IBAction func registerButtonPressed(_ sender: AnyObject) {
        //transition to the registration view
        performSegue(withIdentifier: "loginToRegisterSegue", sender: nil)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //check to see if the user sucessfully registered and then wait until the unwind segue finishes before performing the next one
        if let _ = DataCollector.token {
            self.performSegue(withIdentifier: "loginToMyBeerSegue", sender: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func transitionToMyBeerView()
    {
        //check the login status
        if(status == "ok")
        {
            performSegue(withIdentifier: "loginToMyBeerSegue", sender: nil)
        }
        else
        {
            let alertController = UIAlertController(title: "Login Failed", message: "Username or password Invalid", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
            
        }
    }

    //MARK: Unwind segue from the register view controller
    
    @IBAction func unwindBackToLogin(_ segue: UIStoryboardSegue) {
        //make sure the segue has the correct identifier
        if segue.identifier == "unwindFromRegister" {
            if let sourceVC = segue.source as? RegisterViewController {
                //clear text fields
                sourceVC.firstNameTextField.text = ""
                sourceVC.lastNameTextField.text = ""
                sourceVC.emailTextField.text = ""
                sourceVC.passwordTextField.text = ""
                sourceVC.birthdayTextField.text = ""
                sourceVC.view.window?.endEditing(true)
            }
        }
    }
}


//MARK UITextFieldDelegate method to dismiss keyboard

extension LoginViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
    
}






















