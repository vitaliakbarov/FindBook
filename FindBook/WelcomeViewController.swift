//
//  ContinueViewController.swift
//  FindBook
//
//  Created by Vitali Akbarov on 18/12/2016.
//  Copyright © 2016 Vitali Akbarov. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FBSDKCoreKit
import FBSDKLoginKit

class WelcomeViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{
    
    
    @IBOutlet weak var picker: UIPickerView!
    var pickerData : [String] = [String]()
    let rounds = 30
    var genre : String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        pickerData = AppManager.appManager.getPickerData()
        self.pickerView(picker, didSelectRow: 0, inComponent: 0)
        picker.selectRow(18 * 15, inComponent: 0, animated: true)
    }
    // logout user
    @IBAction func logout(_ sender: UITapGestureRecognizer) {
        
        FBSDKAccessToken.current()
        
        let loginManager = FBSDKLoginManager()
        loginManager.logOut()
        
        let firebaseAuth = FIRAuth.auth()
        do {
            try firebaseAuth?.signOut()
             GoToStoryboard.storyboard.goTo(identifier: "main", viewController: self)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
             AppManager.appManager.showAlert(title: "Error", massage: (signOutError.localizedDescription), viewController: self)
        }
    }
    
    @IBAction func searchForBooks(_ sender: Any) {
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // pass the Genre that was selected
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "genre") {
            
            let detailVC = segue.destination as! SearchedBooksViewController;
            detailVC.stringPassed = genre
            
        }
        
    }
    
    // init the book genre picker
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count * rounds
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        let index = row % pickerData.count
        
        return pickerData[index]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        let index = row % pickerData.count
        genre = pickerData[index]
    }
    
}

