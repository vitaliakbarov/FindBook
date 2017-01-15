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
        
        //   DispatchQueue.main.async {
        print("main")
        let imageName = NSUUID().uuidString
        let unicBookId = NSUUID().uuidString
        let storageRef = FIRStorage.storage().reference().child("bookImages").child(self.uid!).child("\(imageName).png")
        
        if let uploadData = UIImagePNGRepresentation(self.fotoImageView.image!){
            print(uploadData)
            print("upload data")
            
            storageRef.put(uploadData, metadata: nil, completion: { (metadata, error) in
                print("put")
                
                if error != nil{
                    AppManager.appManager.showAlert(title: "Error", massage: (error?.localizedDescription)!, viewController: self)
                    return
                }
                
                if let imgUrl = metadata?.downloadURL()?.absoluteString{
                    AppManager.appManager.addBook(name: self.name!, price: self.price!, uid: self.uid!, janer: self.genre, imgUrl: imgUrl, unicBookId: unicBookId, phone: self.phoneNumber!)
                    print("added")
                }
            })
                     //   }
            
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
    
    
    // open the image picker app with DKImagePicker
    @IBAction func addPhoto(_ sender: UITapGestureRecognizer) {
        
        let pickerController = DKImagePickerController()
        pickerController.maxSelectableCount = 1
        pickerController.singleSelect = true
        let imageSize : CGSize = CGSize.init(width: 84, height: 84)
        pickerController.didSelectAssets = { (assets: [DKAsset]) in
            print("didSelectAssets")
            print(assets)
            for asset in assets {
                
              //  asset.fetchImageWithSize(imageSize, completeBlock: { (image, info) in
                  
              //      self.fotoImageView.image = image
             //   })
                
                asset.fetchOriginalImage(true, completeBlock: { (image, info) in
               let newImage = self.resizeImage(image: image!)
                    self.fotoImageView.image = newImage
                })
                
            }
            
        }
        
        self.present(pickerController, animated: true) {}
    }
    
   //resize image to smaller one , make faster upload to DB
    func resizeImage(image:UIImage) -> UIImage
    {
        var actualHeight:Float = Float(image.size.height)
        var actualWidth:Float = Float(image.size.width)
        
        let maxHeight:Float = 84.0 //your choose height
        let maxWidth:Float = 84.0  //your choose width
        
        var imgRatio:Float = actualWidth/actualHeight
        let maxRatio:Float = maxWidth/maxHeight
        
        if (actualHeight > maxHeight) || (actualWidth > maxWidth)
        {
            if(imgRatio < maxRatio)
            {
                imgRatio = maxHeight / actualHeight;
                actualWidth = imgRatio * actualWidth;
                actualHeight = maxHeight;
            }
            else if(imgRatio > maxRatio)
            {
                imgRatio = maxWidth / actualWidth;
                actualHeight = imgRatio * actualHeight;
                actualWidth = maxWidth;
            }
            else
            {
                actualHeight = maxHeight;
                actualWidth = maxWidth;
            }
        }
         let rect = CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: 84, height: 84))
        //let rect:CGRect = CGRect(0.0, 0.0, CGFloat(actualWidth) , CGFloat(actualHeight) )
        UIGraphicsBeginImageContext(rect.size)
        image.draw(in: rect)
        
        let img:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        let imageData:NSData = UIImageJPEGRepresentation(img, 1.0)! as NSData
        UIGraphicsEndImageContext()
        
        return UIImage(data: imageData as Data)!
    }
    
    //////////////////
    
    // close the current view
    @IBAction func backToMyBooks(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerData = AppManager.appManager.getPickerData()
        picker.selectRow(18 * 15, inComponent: 0, animated: true)
        self.pickerView(picker, didSelectRow: 0, inComponent: 0)
        genre = pickerData[0]
        
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
        if textField == bookNameTextField { // Switch focus to other text field
            priceTextField.becomeFirstResponder()
        }
        if textField == priceTextField { // Switch focus to other text field
            textField.resignFirstResponder()
        }
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == priceTextField{
            let invalidCharacters = CharacterSet(charactersIn: "0123456789").inverted
            return string.rangeOfCharacter(from: invalidCharacters, options: [], range: string.startIndex ..< string.endIndex) == nil
        }
        return true
    }
    
    
}
