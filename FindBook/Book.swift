//
//  Book.swift
//  FindBook
//
//  Created by Vitali Akbarov on 25/12/2016.
//  Copyright © 2016 Vitali Akbarov. All rights reserved.
//

import UIKit

class Book: NSObject {
    
   
    let bookName : String?
    let price : String?
    let image : URL?
    let genre : String?
    let phone : String?
    let bookId : String?
    

    init(bookkkName : String?, prisee : String?, urlString: String?, genree: String?, phonee: String?, unicID: String) {
        bookName = bookkkName
        price = prisee
        image = URL(string: urlString!)
        genre = genree
        phone = phonee
        bookId = unicID
            
        super.init()
    }

}
