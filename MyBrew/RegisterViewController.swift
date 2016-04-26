//
//  RegisterViewController.swift
//  MyBrew
//
//  Created by Jayme Becker on 3/13/16.
//  Copyright © 2016 Jayme Becker. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {
    
    //declare variables
    let registrationUrlString = "https://api-mybrew.rhcloud.com/api/auth/register"
    var dataCollector: DataCollector = DataCollector()

    //declare outlets
    @IBOutlet weak var birthdayTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBAction func cancelButtonPressed(sender: AnyObject) {
        
        performSegueWithIdentifier("unwindFromRegister", sender: nil)
    }
    
    @IBAction func tapToDismissKeyboard(sender: AnyObject) {
        self.view.endEditing(true)
    }
    
    //function to keep track of the birthdayTextField while it is being edited
    @IBAction func birthdayTextFieldEditing(sender: UITextField) {
        //format the text field
        let datePickerView: UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.Date
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(RegisterViewController.birthdayTextFieldValueChanged(_:)), forControlEvents: UIControlEvents.ValueChanged)
    }
    
    //function to send a registration request to our API and perform se
    @IBAction func registerButtonPressed(sender: AnyObject) {
       
        if(passwordTextField.text!.characters.count >= 8)
        {
            let fullName = firstNameTextField.text! + " " + lastNameTextField.text!
            let parameterString = "email=\(emailTextField.text!)&password=\(passwordTextField.text!)&birthday=\(birthdayTextField.text!)&name=\(fullName)"
            
            dataCollector.loginOrRegistrationRequest(registrationUrlString, paramString: parameterString, completionHandler: { (status, errorString) -> Void in
                if let unwrappedErrorString = errorString
                {
                    print(unwrappedErrorString)
                }
                else
                {
                    //self.token = self.dataCollector.token
                    print("User Registered in with token \(DataCollector.token!)")
                    self.performSegueWithIdentifier("unwindFromRegister", sender: nil)
                }
            })
        }
        else
        {
            let alertController = UIAlertController(title: "Invalid Password", message: "password needs to be a minimum of 8 characters", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        

    }
    
    func birthdayTextFieldValueChanged(sender:UIDatePicker)
    {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        birthdayTextField.text = dateFormatter.stringFromDate(sender.date)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
      
    }
}



//MARK UITextFieldDelegate method to dismiss keyboard

extension RegisterViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
    
}
