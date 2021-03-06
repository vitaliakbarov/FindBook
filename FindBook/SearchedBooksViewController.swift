//
//  SearchedBooksViewController.swift
//  FindBook
//
//  Created by Vitali Akbarov on 26/12/2016.
//  Copyright © 2016 Vitali Akbarov. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import Toast

class SearchedBooksViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    //let cellId = "searchCell"
    var stringPassed : String!
    var genre : String?
    var booksArray : [Book] = []
    
    @IBOutlet weak var tableView: UITableView!

    // closing the current view
    @IBAction func backToSearch(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        genre = stringPassed
        searchBook()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // init tableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return booksArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.searchCellIdentifier, for: indexPath) as! SearchesTableViewCell
        let book = booksArray[indexPath.row]
        cell.configure(name: book.bookName!, price: book.price!, url: book.image!, genre: book.genre!)
        
        return cell
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let row : CGFloat = CGFloat.init(100)
        
        return row
    }
    
    // get the searched data from Firebase and parse to Book object 
    func searchBook(){
        
        var ref: FIRDatabaseReference!
        ref = FIRDatabase.database().reference().child(Constants.books)
        ref.queryOrdered(byChild: Constants.janer).queryEqual(toValue: genre).observe(.value, with: { snapshot in
            if snapshot.value is NSNull {
                self.view.makeToast("No Books found", duration: 3, position: CSToastPositionCenter)
               
            } else {
                
                for childSnap in snapshot.children.allObjects as! [FIRDataSnapshot]{
                    let book = Book(snapshot: childSnap)
                    self.booksArray.append(book)
                    self.tableView.reloadData()
                    
                }
            }
        })
        
        self.tableView.reloadData() // refresh table
    }
    
    
    // pass selected object to details controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let identifier = segue.identifier else {
            return
        }
        
        switch identifier {
        case Constants.deatilsSegue:
            
            guard let cell = sender as? UITableViewCell,
                let indexPath = self.tableView.indexPath(for: cell)
                else {
                    return
            }

            let nextVC = segue.destination as? DetailsViewController
            nextVC?.book = booksArray[indexPath.row]
            
        default:
            return
        }
    }
    
}
