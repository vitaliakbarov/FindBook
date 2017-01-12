//
//  AddBookViewController.swift
//  FindBook
//
//  Created by Vitali Akbarov on 25/12/2016.
//  Copyright © 2016 Vitali Akbarov. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import DKImagePickerController

class AddBookViewController: UIViewController , UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate{
    
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var bookNameTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var addButton: UIButton!
    
    @IBOutlet weak var fotoImageView: UIImageView!
    
    var book : Book?
    var pickerData : [String] = [String]()
    let rounds = 30
    var genre : String = ""
    let storage = FIRStorage.storage()
    var bookImageUrl : String? = nil
    let uid = FIRAuth.auth()?.currentUser?.uid
    var name : String?
    var price : String?
    var phoneNumber : String? = ""
    
    // add book button was pressed
    @IBAction func addBook(_ sender: Any) {
        name = bookNameTextField.text
        price = priceTextField.text
        if (name?.isEmpty)! || (price?.isEmpty)!{
            AppManager.appManager.showAlert(title: "Empty", massage: "Empty fields", viewController: self)
            return
        }
        getUserPhone()
        addNewBook()
        
        // remove old version of book to sell
        if addButton.currentTitle == "עדכן"{
            var ref: FIRDatabaseReference!
            let bookIdToRemove = book?.bookId
            ref = FIRDatabase.database().reference().child("books")
            ref.child(bookIdToRemove!).removeValue()
        }
        self.dismiss(animated: true, completion: nil)
        
    }
    // add new book for sell and save the book in DB
    func addNewBook()  {
        let imageName = NSUUID().uuidString
        let unicBookId = NSUUID().uuidString
        let storageRef = FIRStorage.storage().reference().child("bookImages").child(uid!).child("\(imageName).png")
        
        if let uploadData = UIImagePNGRepresentation(self.fotoImageView.image!){
            
            storageRef.put(uploadData, metadata: nil, completion: { (metadata, error) in
                
                if error != nil{
                    AppManager.appManager.showAlert(title: "Error", massage: (error?.localizedDescription)!, viewController: self)
                    return
                }
                
                if let imgUrl = metadata?.downloadURL()?.absoluteString{
                    AppManager.appManager.addBook(name: self.name!, price: self.price!, uid: self.uid!, janer: self.genre, imgUrl: imgUrl, unicBookId: unicBookId, phone: self.phoneNumber!)
                }
            })
        }
    }
    // get user phone number prom DB to save the contact phohe
    func getUserPhone() {
        var ref: FIRDatabaseReference!
        ref = FIRDatabase.database().reference().child("users")
        ref.queryOrdered(byChild: "id").queryEqual(toValue: uid).observe(.value, with: { snapshot in
            if snapshot.value is NSNull {
                print("phone number empty")
            } else {
                for childSnap in snapshot.children.allObjects as! [FIRDataSnapshot]{
                    self.phoneNumber = childSnap.childSnapshot(forPath: "phone").value as? String
                }
            }
        })
        
    }
    
    // handle the image that choosed
    func handle(asset : DKAsset){
        let imageSize : CGSize = CGSize.init(width: 84, height: 84)
        
        asset.fetchImageWithSize(imageSize, completeBlock: { (image, _) in
            if let image = image{
                self.fotoImageView.image = image
            }
        })
    }
    
    // open the image picker app with DKImagePicker
    @IBAction func addPhoto(_ sender: UITapGestureRecognizer) {
        
        let pickerController = DKImagePickerController()
        pickerController.maxSelectableCount = 1
        pickerController.didSelectAssets = { assets in //[DKAssets]
            for item in assets{
                self.handle(asset: item)
            }
        }
        present(pickerController, animated: true, completion: nil)
        
    }
    
    
    // close the current view
    @IBAction func backToMyBooks(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerData = AppManager.appManager.getPickerData()
        picker.selectRow(18 * 15, inComponent: 0, animated: true)
        self.pickerView(picker, didSelectRow: 0, inComponent: 0)
        
        // user choose to edit the book
        if book != nil {
            editBook()
        }
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    // prepare to edit the book
    func editBook()  {
        bookNameTextField.text = book?.bookName
        priceTextField.text = book?.price
        addButton.setTitle("עדכן", for: UIControlState.normal)
        self.fotoImageView.sd_setImage(with: book?.image)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // init picker
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
    
}
