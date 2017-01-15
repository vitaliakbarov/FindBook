//
//  DetailsViewController.swift
//  FindBook
//
//  Created by Vitali Akbarov on 07/01/2017.
//  Copyright © 2017 Vitali Akbarov. All rights reserved.
//

import UIKit
import SDWebImage

class DetailsViewController: UIViewController {
    
    var book : Book!
    
    
    @IBOutlet weak var bookImageView: UIImageView!
    
    @IBOutlet weak var bookNameLable: UILabel!
    @IBOutlet weak var bookGenreLable: UILabel!
    @IBOutlet weak var bookPriceLable: UILabel!
    @IBOutlet weak var bookSellerPhone: UILabel!
    
    // closing the current view
    @IBAction func backToSearch(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // NOT WORKING ON SIMULATOR this is the call action
    
     @IBAction func callToSeller(_ sender: UITapGestureRecognizer) {
     
        print("tap")
        
        guard let number = URL(string: "telprompt://" + book.phone!) else { return }
        UIApplication.shared.open(number, options: [:], completionHandler: nil)

  }
     
     
    override func viewDidLoad() {
        super.viewDidLoad()
        initBook()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // init the fields
    func initBook()  {
        self.bookNameLable.text =  book.bookName
        self.bookGenreLable.text = book.genre
        self.bookPriceLable.text = "מחיר: " + book.price! + " שח"
        self.bookImageView.sd_setImage(with: book.image)
        self.bookSellerPhone.text = "טלפון: " + book.phone!
        
    }
    
}
