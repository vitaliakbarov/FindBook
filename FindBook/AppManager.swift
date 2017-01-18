//
//  RegisterUser.swift
//  FindBook
//
//  Created by Vitali Akbarov on 20/12/2016.
//  Copyright © 2016 Vitali Akbarov. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase


class AppManager: NSObject{
    
    static let appManager = AppManager()
    
    //FIRApp.configure()
    
    
    // Validate User registration
    func validate(name: String, email: String, password: String, confirmPassword: String, phone: String) -> Bool {
        
        if (email.isEmpty) || (password.isEmpty) || (confirmPassword.isEmpty) || (phone.isEmpty) || (name.isEmpty){
            return false
        }
        if password != confirmPassword {
            print("confirm password faild")
                      return false
        }
        
        return true
        
    }
    
    // Register User Information
    func registerWith(phone: String, name: String, uid: String, email: String){
        
        var ref: FIRDatabaseReference!
        
        ref = FIRDatabase.database().reference()
        
        ref.child("users").child(uid).setValue(["username": name, "email": email, "phone": phone, "id": uid])
        
    }
    
    
    // ADD Book for sale
    func addBook(name: String, price: String, uid: String, janer: String, imgUrl: String, unicBookId: String, phone: String){
        
        var ref: FIRDatabaseReference!
        
        ref = FIRDatabase.database().reference()
        
        ref.child("books").child(unicBookId).setValue(["bookName": name, "price": price,  "userId": uid, "janer": janer, "imgUrl": imgUrl, "unicBookId": unicBookId, "phone": phone])
    }
    
     
    // returning picker data
    
    func getPickerData() -> [String] {
      let pickerData = ["אוטוביוגרפיה" , "בישול" , "דרמה" , "הומור" , "היסטוריה" , "טיולים" , "יהדות" , "לימוד" , "מדע בדיוני" , "מחשבים" ,
                      "פילוסופיה" , "פנטזיה" , "פסיכולוגיה" , "רומן" , "שירה" , "מתח" , "תזונה" , "הרפתקאות"]
        
        return pickerData
    }
    
}

