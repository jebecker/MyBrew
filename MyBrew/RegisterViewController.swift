//
//  RegisterViewController.swift
//  MyBrew
//
//  Created by Jayme Becker on 3/13/16.
//  Copyright © 2016 Jayme Becker. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {

    let registrationUrlString = "https://api-mybrew.rhcloud.com/api/auth/register"
    var dataCollector: DataCollector = DataCollector()
    var token: String = "nothing"
    //var fullName: String = ""
    
    @IBOutlet weak var birthdayTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBAction func birthdayTextFieldEditing(sender: UITextField) {
        //format the text field
        let datePickerView: UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.Date
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: Selector("birthdayTextFieldValueChanged:"), forControlEvents: UIControlEvents.ValueChanged)
    }
    
    @IBAction func registerButtonPressed(sender: AnyObject) {
       
        
        if(passwordTextField.text!.characters.count >= 8)
        {
            let fullName = firstNameTextField.text! + " " + lastNameTextField.text!
            let parameterString = "email=\(emailTextField.text!)&password=\(passwordTextField.text!)&birthday=\(birthdayTextField.text!)&name=\(fullName)"
            
            dataCollector.loginOrRegistrationRequest(registrationUrlString, paramString: parameterString, completionHandler: { (data, errorString) -> Void in
                if let unwrappedErrorString = errorString
                {
                    print(unwrappedErrorString)
                }
                else
                {
                    self.token = self.dataCollector.token
                    print("User Registered in with token \(self.token)")
                }
                
            })
            
            performSegueWithIdentifier("registrationToMyBeersSegue", sender: nil)

        }
        else
        {
            let alertController = UIAlertController(title: "Invalid Password", message: "password needs to be a minimum of 8 characters", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        

    }
    @IBAction func cancelButtonPressed(sender: AnyObject) {
        //clear text fields
        firstNameTextField.text = ""
        lastNameTextField.text = ""
        emailTextField.text = ""
        passwordTextField.text = ""
        birthdayTextField.text = ""
        
        self.view.window?.endEditing(true)
        
        performSegueWithIdentifier("cancelRegistrationSegue", sender: nil)
        
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
