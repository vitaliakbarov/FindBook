//
//  ForgotPasswordViewController.swift
//  FindBook
//
//  Created by Vitali Akbarov on 18/12/2016.
//  Copyright © 2016 Vitali Akbarov. All rights reserved.
//

import UIKit
import FirebaseAuth

class ForgotPasswordViewController: UIViewController , UITextFieldDelegate{
    
    @IBOutlet weak var emailField: UITextField!
    
    
    
    var email : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    
    @IBAction func sendButton(_ sender: UIButton) {
        
        email = emailField.text
        
        if (email?.isEmpty)! {
            
            AppManager.appManager.showAlert(title: "Error", massage: "Enter Email", viewController: self)
            return
        }else{
            
            FIRAuth.auth()?.sendPasswordReset(withEmail: email!) { (error) in
                AppManager.appManager.showAlert(title: "Error", massage: (error?.localizedDescription)!, viewController: self)
            }
            AppManager.appManager.showAlert(title: "Sent", massage: "Reset password was sent to your mail.", viewController: self)
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    
    
}
