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

        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tapGestureRecognizer)
        
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
        
        if let selectedImage = info[.originalImage] as? UIImage {
                imageView.image = selectedImage
            }
            dismiss(animated: true, completion: nil)
    }
    
    @objc func handleTap() {
        view.endEditing(true)
    }
    
    @IBAction func actionButtonClicked(_ sender: Any)
    {
        if let imageData = imageView.image?.jpegData(compressionQuality: 0.5)
        {
            let uuid = UUID().uuidString
            let imageReference = Storage.storage().reference().child("media").child("\(uuid).jpg")

            imageReference.putData(imageData, metadata: nil) { (storageMetadata, error) in
                if let error = error
                {
                    self.makeAlert(titleInput: "Error!", messageInput: error.localizedDescription)
                } else
                {
                    imageReference.downloadURL { (url, error) in
                        if let error = error
                        {
                            self.makeAlert(titleInput: "Error!", messageInput: error.localizedDescription)
                        } else if let imageUrl = url?.absoluteString
                        {
                            let firestoreDatabase = Firestore.firestore()
                            let postDocument = firestoreDatabase.collection("Members").document(Auth.auth().currentUser!.email!).collection("Posts").document()
                            let postDictionary: [String: Any] = [
                                "imageurl": imageUrl,
                                "comment": self.commentText.text ?? "",
                                "email": Auth.auth().currentUser!.email ?? "",
                                "date": FieldValue.serverTimestamp(),
                                "like": 0
                            ]
                            postDocument.setData(postDictionary) { error in
                                if let error = error
                                {
                                    self.makeAlert(titleInput: "Error!", messageInput: error.localizedDescription)
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
    
    @IBAction func openCameraButton(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.camera)
        {
                    imagePicker.sourceType = .camera
                    imagePicker.allowsEditing = false
                    imagePicker.delegate = self
                    present(imagePicker, animated: true, completion: nil)
                    
                } else
                {
                    print("Kamera kullanılamıyor.")
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
