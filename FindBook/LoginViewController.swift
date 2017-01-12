//
//  LoginViewController.swift
//  FindBook
//
//  Created by Vitali Akbarov on 18/12/2016.
//  Copyright © 2016 Vitali Akbarov. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FacebookLogin
import FacebookCore
import FBSDKCoreKit



class LoginViewController: UIViewController, UITextFieldDelegate,LoginButtonDelegate{
    
    
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButtonContainer: UIView!
    
    var email : String?
    var password : String?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let loginButton = LoginButton(readPermissions: [ .publicProfile, .email ])
        loginButton.frame = loginButtonContainer.bounds
        loginButton.delegate = self
        loginButtonContainer.addSubview(loginButton)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
   
    
    func loginButtonDidCompleteLogin(_ loginButton: LoginButton, result: LoginResult) {
        if AccessToken.current == nil{
            print("not logged in")
            
        } else {
            print("logged in")
            let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
            
            
            FIRAuth.auth()?.signIn(with: credential) { (user, error) in
                UIApplication.shared.delegate?.window??.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "logged")
                
                if let error = error {
                    
                    AppManager.appManager.showAlert(title: "Error", massage: error as! String, viewController: self)
                    return
                }
            }
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: LoginButton) {
        
    }
    
    
    
    @IBAction func loginButton(_ sender: UIButton) {
        
        email = emailField.text
        password = passwordField.text
        if validate() {
            FIRAuth.auth()?.signIn(withEmail: email!, password: password!) { (user, error) in
                
                if error != nil{
                    AppManager.appManager.showAlert(title: "Error", massage: (error?.localizedDescription)!, viewController: self)
                    
                }else{
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let controller = storyboard.instantiateViewController(withIdentifier: "logged")
                    self.present(controller, animated: true, completion: nil)
                    // ...
                }
            }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func validate() -> Bool{
        if (email?.isEmpty)! || (password?.isEmpty)!{
            AppManager.appManager.showAlert(title: "Empty", massage: "text fields are empty", viewController: self)
            return false
        }else{
            
            return true
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField == emailField { // Switch focus to other text field
            passwordField.becomeFirstResponder()
        }
        if textField == passwordField { // Switch focus to other text field
            textField.resignFirstResponder()
        }
        return true
    }
    
    
}
