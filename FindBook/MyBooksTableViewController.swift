//
//  MyBooksTableViewController.swift
//  FindBook
//
//  Created by Vitali Akbarov on 25/12/2016.
//  Copyright © 2016 Vitali Akbarov. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class MyBooksTableViewController: UIViewController , UITableViewDataSource, UITableViewDelegate {
    
    var booksArray : [Book] = []
    let myUid : String = (FIRAuth.auth()?.currentUser?.uid)!
    
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.booksArray = []
        self.tabBarController?.tabBar.isHidden = false
        searchBook()
        self.tableView.reloadData()
        
    }
    
    // init my book table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return booksArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.myBooksCellIdentifier, for: indexPath) as! MyBooksTableViewCell
        let book = booksArray[indexPath.row]
        cell.configure(name: book.bookName!, price: book.price!, url: book.image!, genre: book.genre!)
        
        return cell
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let row : CGFloat = CGFloat.init(100)
        
        return row
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else {
            return
        }
        
        // remove the object from the table and from DB
        var ref: FIRDatabaseReference!
        let book = booksArray[indexPath.row]
        let bookIdToRemove = book.bookId
        booksArray.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .left)
        ref = FIRDatabase.database().reference().child(Constants.books)
        ref.child(bookIdToRemove!).removeValue()
    }
    
    func searchBook(){
        var ref: FIRDatabaseReference!
        
        ref = FIRDatabase.database().reference().child(Constants.books)
        
        ref.queryOrdered(byChild: Constants.userId).queryEqual(toValue: myUid).observe(.value, with: { snapshot in
            if snapshot.value is NSNull {
               
            } else {
                self.booksArray = []
                for childSnap in snapshot.children.allObjects as! [FIRDataSnapshot]{
                    let book = Book(snapshot: childSnap)
                    self.booksArray.append(book)
                    self.tableView.reloadData()
                    
                }
            }
        })
    }
    
    
    // PASS book object to edit
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let identifier = segue.identifier else {
            return
        }
        switch identifier {
        case Constants.editBookSegue:
            guard let cell = sender as? UITableViewCell,
                let indexPath = self.tableView.indexPath(for: cell)
                else {
                    return
            }
            
            let nextVC = segue.destination as? AddBookViewController
            nextVC?.book = booksArray[indexPath.row]
            
        default:
            return
        }
    }
    
    
    
}
