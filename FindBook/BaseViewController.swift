//
//  BaseViewController.swift
//  FindBook
//
//  Created by Vitali Akbarov on 18/12/2016.
//  Copyright © 2016 Vitali Akbarov. All rights reserved.
//

import UIKit
import FirebaseAuth
import FacebookLogin
import FacebookCore
import FBSDKCoreKit

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if FIRAuth.auth()?.currentUser != nil {
            // User is signed in.
            print("signed in")
            
            GoToStoryboard.storyboard.goTo(identifier: Constants.loggedIdentifier, viewController: self)
            
        } else {
            // No user is signed in.
            
            GoToStoryboard.storyboard.goTo(identifier: Constants.mainIdentifier, viewController: self)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
