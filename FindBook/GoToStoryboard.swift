//
//  GoToStoryboard.swift
//  FindBook
//
//  Created by Vitali Akbarov on 23/12/2016.
//  Copyright © 2016 Vitali Akbarov. All rights reserved.
//

import UIKit

class GoToStoryboard: NSObject {
    
    static let storyboard = GoToStoryboard()
    
    var window: UIWindow?
    
    func goTo(identifier: String, viewController : UIViewController) {
        
        let storyboard = UIStoryboard(name: Constants.Main, bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: identifier)
        viewController.present(controller, animated: true, completion: nil)
        
        
    }
    
    
}
