//
//  EditProfileVC.swift
//  bossia
//
//  Created by ONUR BOSTAN on 4.08.2023.
//

import UIKit
import Firebase

class EditProfileVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var editProfileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var nameText: UITextField!
    
    var currentUser = Auth.auth().currentUser
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        editProfileImageView.layer.borderWidth = 2.0
        editProfileImageView.layer.borderColor = UIColor.systemYellow.cgColor
        
        //Label'e; girişi yapılan kullanıcının mailini göstermek için;
        self.userNameLabel.text = "\(Auth.auth().currentUser!.email!)"
        
        //EditProfil kısmındaki değişen Name: bölümünün karşımıza çıkabilmesi için;
        if let userNames = Auth.auth().currentUser
        {
            currentUser = userNames
            nameText.text = currentUser?.displayName
        }
        
        //EditProfil kısmındaki değişen fotoğrafın bölümünün karşımıza çıkabilmesi için;
        if let user = Auth.auth().currentUser
        {
            updateProfilePhoto()
        }
        
        
        //Fotoğrafın tıklanabilir, değişebilir ve kaydetme işlemleri için
        editProfileImageView.isUserInteractionEnabled = true
        let gesturesRecognizer = UITapGestureRecognizer(target: self, action: #selector(choosesPhoto))
        editProfileImageView.addGestureRecognizer(gesturesRecognizer)
    }
    @objc func choosesPhoto()
    {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        picker.dismiss(animated: true)
        if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        {
            editProfileImageView.image = selectedImage
            saveImageToFirebase(image: selectedImage)
        }
    }
    func saveImageToFirebase(image: UIImage)
    {
        guard let userID = Auth.auth().currentUser?.email else
        {
            return
        }
        let storageRef = Storage.storage().reference().child("profilePhoto").child("\(userID).jpg")
        if let imageData = editProfileImageView.image?.jpegData(compressionQuality: 0.5)
        {
            let uploadTask = storageRef.putData(imageData, metadata: nil) { (metadata, error) in
                if let error = error
                {
                    print("Error!")
                } else
                {
                    self.updateProfilePhoto()
                }
            }
        }
    }
    func updateProfilePhoto()
    {
        guard let userID = Auth.auth().currentUser?.email else
        {
            return
        }
        let storageRef = Storage.storage().reference().child("profilePhoto").child("\(userID).jpg")
        storageRef.getData(maxSize: 1 * 1024 * 1024) { (data, error) in
            if let error = error
            {
                print("Error!")
            } else
            {
                if let data = data, let profileImage = UIImage(data: data) {
                    self.editProfileImageView.image = profileImage
                }
            }
        }
    }
    
    
    
    @IBAction func finishedButtonClicked(_ sender: UIButton) {
        guard let newUsername = nameText.text else
        {
                    return
                }
                let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                changeRequest?.displayName = newUsername
                changeRequest?.commitChanges(completion: { error in
                    if let error = error
                    {
                        self.makeAlert(titleInput: "Error!", messageInput: error.localizedDescription)
                    } else
                    {
                        let fireStoreDatabase = Firestore.firestore()
                        let firestorePost = ["userName": self.nameText.text!] as [String : Any]
                        fireStoreDatabase.collection("Users").addDocument(data: firestorePost) { (error) in
                            if error != nil
                            {
                                self.makeAlert(titleInput: "Error!", messageInput: error?.localizedDescription ?? "Error!")
                            } else
                            {
                                self.performSegue(withIdentifier: "toTabBarVC", sender: nil)
                                
                            }
                        }
                    }
                })
    }
    
    
    @IBAction func cancelButtonClicked(_ sender: Any) {
        self.performSegue(withIdentifier: "toTabBarVC", sender: nil)
    }
    
    
    
    
    //GENEL UYARI MESAJLARI
    func makeAlert(titleInput: String, messageInput: String)
    {
        let alert = UIAlertController(title: title, message: messageInput, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okButton)
        self.present(alert, animated: true)
    }
}
