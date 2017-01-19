//
//  Book.swift
//  FindBook
//
//  Created by Vitali Akbarov on 25/12/2016.
//  Copyright © 2016 Vitali Akbarov. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class Book: NSObject {
    
   
    let bookName : String?
    let price : String?
    let image : URL?
    let genre : String?
    let phone : String?
    let bookId : String?
    
/*
    init(bookkkName : String?, prisee : String?, urlString: String?, genree: String?, phonee: String?, unicID: String) {
        bookName = bookkkName
        price = prisee
        image = URL(string: urlString!)
        genre = genree
        phone = phonee
        bookId = unicID
            
        super.init()
    }
    */
    init(snapshot: FIRDataSnapshot) {
        
        bookName = snapshot.childSnapshot(forPath: Constants.bookName).value as? String
        price = snapshot.childSnapshot(forPath: Constants.price).value as? String
        image = URL(string: (snapshot.childSnapshot(forPath: Constants.imgUrl).value as? String)!)
        genre = snapshot.childSnapshot(forPath: Constants.janer).value as? String
        phone = snapshot.childSnapshot(forPath: Constants.phone).value as? String
        bookId = snapshot.childSnapshot(forPath: Constants.unicBookId).value as? String
        
     
        
        super.init()
    }

}
