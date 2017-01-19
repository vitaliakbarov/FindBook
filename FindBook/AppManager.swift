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
        
        ref.child(Constants.users).child(uid).setValue([Constants.username: name, Constants.email: email, Constants.phone: phone, Constants.id: uid])
        
    }
    
    
    // ADD Book for sale
    func addBook(name: String, price: String, uid: String, janer: String, imgUrl: String, unicBookId: String, phone: String){
        
        var ref: FIRDatabaseReference!
        
        ref = FIRDatabase.database().reference()
        
        ref.child(Constants.books).child(unicBookId).setValue([Constants.bookName: name, Constants.price: price,  Constants.userId: uid, Constants.janer: janer, Constants.imgUrl: imgUrl, Constants.unicBookId: unicBookId, Constants.phone: phone])
    }
    
     
    // returning picker data
    
    func getPickerData() -> [String] {
        var myArray: [String] = []
        if let URL = Bundle.main.url(forResource: "PickerDataList", withExtension: "plist") {
            if let genresFromPlist = NSArray(contentsOf: URL) as? [String] {
                for myGenres in genresFromPlist {
                    myArray.append(myGenres)
                }
            }
        }
       // print(myArray)
        return myArray
    }
    
    // make price with number formater
    func numberFormater(st : String) -> String {
        var price : NSNumber?
        if let myInteger = Int(st) {
            price = NSNumber(value:myInteger)
            //price = myNumber
        }
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "he_IL")
        return formatter.string(from: price!)!
    }


  }

