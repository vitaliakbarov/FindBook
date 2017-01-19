//
//  RegisterViewController.swift
//  FindBook
//
//  Created by Vitali Akbarov on 17/12/2016.
//  Copyright © 2016 Vitali Akbarov. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import Toast

class RegisterViewController: UIViewController , UITextFieldDelegate{
    
    
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var phoneNumberField: UITextField!
    
    
    
    var email : String?
    var password : String?
    var confirmPassword : String?
    var name : String?
    var phone : String?
    var id : String?
    var window : UIWindow?
    
    
    
    
    @IBAction func registerButton(_ sender: UIButton) {
        
        email = emailField.text
        password = passwordField.text
        confirmPassword = confirmPasswordField.text
        name = nameField.text
        phone = phoneNumberField.text
        
       let valid = AppManager.appManager.validate(name: name!, email: email!, password: password!, confirmPassword: confirmPassword!, phone: phone!)
        
        if valid {
            FIRAuth.auth()?.createUser(withEmail: emailField.text!, password: passwordField.text!, completion: { (user, error) in
                
                if error != nil {
                    self.view.makeToast(error?.localizedDescription, duration: 3, position: CSToastPositionCenter)
                   
                }else{
                    self.id = FIRAuth.auth()?.currentUser?.uid
                    AppManager.appManager.registerWith(phone: self.phone!, name: self.name!, uid: self.id!, email: self.email!)
                    
                    GoToStoryboard.storyboard.goTo(identifier: Constants.loggedIdentifier, viewController: self)
                    
                }
            })
        }else{
              self.view.makeToast("Empty fields or bad confirmatiom", duration: 3, position: CSToastPositionCenter)
            
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // active the next Button on keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField == emailField { // Switch focus to other text field
            passwordField.becomeFirstResponder()
        }
        if textField == passwordField { // Switch focus to other text field
            confirmPasswordField.becomeFirstResponder()
        }
        if textField == confirmPasswordField { // Switch focus to other text field
            nameField.becomeFirstResponder()
        }
        if textField == nameField { // Switch focus to other text field
            phoneNumberField.becomeFirstResponder()
        }
        return true
    }
    
}
