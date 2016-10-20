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
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBAction func cancelButtonPressed(_ sender: AnyObject) {
        
        performSegue(withIdentifier: "unwindFromRegister", sender: nil)
    }
    
    @IBAction func tapToDismissKeyboard(_ sender: AnyObject) {
        self.view.endEditing(true)
    }
    
    //function to keep track of the birthdayTextField while it is being edited
    @IBAction func birthdayTextFieldEditing(_ sender: UITextField) {
        //format the text field
        let datePickerView: UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.date
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(RegisterViewController.birthdayTextFieldValueChanged(_:)), for: UIControlEvents.valueChanged)
    }
    
    //function to send a registration request to our API and perform se
    @IBAction func registerButtonPressed(_ sender: AnyObject) {
       
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
                    self.performSegue(withIdentifier: "unwindFromRegister", sender: nil)
                }
            })
        }
        else
        {
            let alertController = UIAlertController(title: "Invalid Password", message: "password needs to be a minimum of 8 characters", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
        }
        

    }
    
    func birthdayTextFieldValueChanged(_ sender:UIDatePicker)
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        birthdayTextField.text = dateFormatter.string(from: sender.date)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set content insets for the scroll view
        self.scrollView.contentInset = UIEdgeInsetsMake(0.0, 0.0, 88.0, 0.0)
        self.scrollView.scrollIndicatorInsets = UIEdgeInsetsMake(0.0, 0.0, 80.0, 0.0)
      
    }
}



//MARK UITextFieldDelegate method to dismiss keyboard

extension RegisterViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
    
}
