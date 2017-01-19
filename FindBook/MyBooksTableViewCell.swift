//
//  MyBooksTableViewCell.swift
//  FindBook
//
//  Created by Vitali Akbarov on 04/01/2017.
//  Copyright © 2017 Vitali Akbarov. All rights reserved.
//

import UIKit

class MyBooksTableViewCell: UITableViewCell {
    
    
    
    @IBOutlet weak var bookImageView: UIImageView!
    @IBOutlet weak var bookNameLable: UILabel!
    @IBOutlet weak var bookPriceLable: UILabel!
    @IBOutlet weak var bookGenre: UILabel!
    
    static let identifier = Constants.myBooksCellIdentifier
    // configure the cell
    func configure(name: String, price: String, url: URL, genre: String){
        let formatedPrice =  AppManager.appManager.numberFormater(st: price)
        bookNameLable.text = name
        //bookPriceLable.text = "מחיר: " + price + " " + "שח"
        bookPriceLable.text = "מחיר: " + formatedPrice
        bookGenre.text = genre
        bookImageView.sd_setImage(with: url)
        
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
 }
