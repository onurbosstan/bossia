//
//  UploadVC.swift
//  bossia
//
//  Created by ONUR BOSTAN on 21.07.2023.
//

import UIKit
import Firebase

class UploadVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var commentText: UITextField!
    
    let imagePicker = UIImagePickerController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        imageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(chooseImage))
        imageView.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc func chooseImage()
    {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
        present(pickerController, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        imageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true)
    }
    
    @IBAction func actionButtonClicked(_ sender: Any)
    {
        let storage = Storage.storage()
        let storageReference = storage.reference() //referans belirleriz; gideceğimiz dosyayı söyleriz;
        let mediaFolder = storageReference.child("media") //   "media" isminde bir klasör açtık;
        if let data = imageView.image?.jpegData(compressionQuality: 0.5)
        {
            let uuid = UUID().uuidString
            let imageReference = mediaFolder.child("\(uuid).jpg")
            imageReference.putData(data) { (storageMetadata, error) in
                if error != nil
                {
                    self.makeAlert(titleInput: "Error!", messageInput: error?.localizedDescription ?? "Error!, Try again!")
                } else
                {
                    imageReference.downloadURL { (url, error) in
                        if error == nil {
                            let imageUrl = url?.absoluteString
                            if let imageUrl = imageUrl
                            {
                                
                                //DATABASE
                                
                                let fireStoreDatabase = Firestore.firestore()
                                let firestorePost = ["imageurl" : imageUrl, "comment" : self.commentText.text!, "email" : Auth.auth().currentUser!.email!, "date" : FieldValue.serverTimestamp(), "like" : 0] as [String : Any]
                                fireStoreDatabase.collection("Post").addDocument(data: firestorePost) { (error) in
                                    if error != nil {
                                        self.makeAlert(titleInput: "Error!", messageInput: error?.localizedDescription ?? "Error!")
                                    } else
                                    {
                                        self.commentText.text = ""
                                        self.imageView.image = UIImage(named: "select")
                                        self.tabBarController?.selectedIndex = 0
                                        
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    
    
   
    func makeAlert(titleInput: String, messageInput: String)
    {
        let alert = UIAlertController(title: title, message: messageInput, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okButton)
        self.present(alert, animated: true)
    }
}
