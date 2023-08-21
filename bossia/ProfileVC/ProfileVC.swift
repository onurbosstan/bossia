//
//  ProfileVC.swift
//  bossia
//
//  Created by ONUR BOSTAN on 21.07.2023.
//

import UIKit
import Firebase
import SDWebImage

class ProfileVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var postsLabel: UILabel!
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var openMenuButton: UIButton!
    @IBOutlet weak var profilePhotoImageView: UIImageView!
    @IBOutlet weak var profileNameLabel: UILabel!
    
    var menuOptions = ["Settings & Privacy", "Logout"]
    
    var following: Int = 0
    var followers: Int = 0
    var postLab: Int = 0
    
    var memberEmailArray = [String]()
    var memberImageArray = [String]()
    var memberDocumentArray = [String]()
    
    let db = Firestore.firestore()
    let currentUserID = Auth.auth().currentUser!.email!
    var isFollowing = false
    
    @IBOutlet weak var followButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profilePhotoImageView.layer.borderWidth = 2.0
        profilePhotoImageView.layer.borderColor = UIColor.systemYellow.cgColor
        
        self.profileNameLabel.text = "\(Auth.auth().currentUser!.email!)"
        
        followingLabel.text = String(following)
        followersLabel.text = String(followers)
        postsLabel.text = String(postLab)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.collectionViewLayout = UICollectionViewFlowLayout()
        collectionView.collectionViewLayout = CollectionLayout(colmnsNumber: 3, minColmnsNumber: 1, minCell: 1)
        
        
        getDataFromProfile()
        followUser(userID: currentUserID)
        
        
        
        //Karşısına güncel fotoğraf çıkması için;
        if let user = Auth.auth().currentUser
        {
            updateProfilePhoto()
        }
        
        //PROFİL FOTOĞRAFI;
        profilePhotoImageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(chooseImage))
        profilePhotoImageView.addGestureRecognizer(gestureRecognizer)
    }
    
    //PROFİL FOTOĞRAFI
    @objc func chooseImage()
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
            profilePhotoImageView.image = selectedImage
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
        if let imageData = profilePhotoImageView.image?.jpegData(compressionQuality: 0.5) {
            let uploadTask = storageRef.putData(imageData, metadata: nil) { (metadata, error) in
                if let error = error {
                    print("Error!")
                } else
                {
                    self.updateProfilePhoto()
                }
            }
        }
    }
    func updateProfilePhoto() {
        guard let userID = Auth.auth().currentUser?.email else {
            return
        }
        let storageRef = Storage.storage().reference().child("profilePhoto").child("\(userID).jpg")
        storageRef.getData(maxSize: 1 * 1024 * 1024) { (data, error) in
            if let error = error {
                print("Error!")
            } else {
                if let data = data, let profileImage = UIImage(data: data) {
                    self.profilePhotoImageView.image = profileImage
                }
            }
        }
    }

    //PROFILE MAIN
    func getDataFromProfile() {
        guard let currentUserID = Auth.auth().currentUser?.email! else {
            return
        }
        
        let fireStoreDatabase = Firestore.firestore()
        fireStoreDatabase.collection("Members").document(currentUserID).collection("Posts").order(by: "date", descending: true).addSnapshotListener { (snapshot, error) in
            if error != nil {
                self.makeAlert(titleInput: "Error!", messageInput: error?.localizedDescription ?? "Error!")
            } else {
                if let snapshot = snapshot
                {
                    self.memberEmailArray.removeAll()
                    self.memberImageArray.removeAll()

                    for document in snapshot.documents
                    {
                        let documentID = document.documentID
                        self.memberDocumentArray.append(documentID)
                        
                        if let userEmail = document.get("email") as? String
                        {
                            self.memberEmailArray.append(userEmail)
                        }
                        if let userImage = document.get("imageurl") as? String
                        {
                            self.memberImageArray.append(userImage)
                            self.reloadPage()
                        }
                    }
                }
            }
        }
    }
    private func reloadPage()
    {
        self.collectionView.reloadData()
        self.postsLabel.text = "\(self.memberImageArray.count)"
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return memberEmailArray.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "toCVC", for: indexPath) as! ProfileCell
        cell.collectionImageView.sd_setImage(with: URL(string: self.memberImageArray[indexPath.row]))
        return cell
    }

    
    
    //FOLLOW
    @IBAction func followButtonTapped(_ sender: UIButton)
    {
        if isFollowing
        {
            unfollowUser(userID: currentUserID)
        } else
        {
            followUser(userID: currentUserID)
        }
    }
    func followUser(userID: String)
    {
        db.collection("Members").document(currentUserID).getDocument { (documentSnapshot, error) in
            if let document = documentSnapshot, document.exists {
                let userData = document.data()
                let followerCount = userData?["followerCount"] as? Int ?? 0
                self.followersLabel.text = "\(followerCount)"
            } else {
                self.followersLabel.text = "0"
            }
        }
 
        db.collection("Members").document(currentUserID).updateData(["following":FieldValue.arrayUnion([userID])])
        db.collection("Members").document(userID).updateData(["followers":FieldValue.arrayUnion([currentUserID])])
        isFollowing = true
        followingLabel.text = String(following + 1)
        updateFollowButtonTitle()
    }
    func unfollowUser(userID: String)
    {
        db.collection("Members").document(currentUserID).updateData(["following": FieldValue.arrayRemove([userID])])
        db.collection("Members").document(userID).updateData(["followers":FieldValue.arrayUnion([currentUserID])])
        isFollowing = false
        followingLabel.text = String(following)
        updateFollowButtonTitle()
    }
    func updateFollowButtonTitle()
    {
        let title = isFollowing ? "Unfollow" : "Follow"
        followButton.setTitle(title, for: .normal)
    }
    
    
    
    
    
    
    //AÇILIR MENÜ İÇİN;
    func setupButtonAppearance()
    {
            openMenuButton.layer.cornerRadius = 10
            openMenuButton.layer.borderWidth = 1
            openMenuButton.layer.borderColor = UIColor.gray.cgColor
            openMenuButton.setTitleColor(.gray, for: .normal)
        }
    func handleMenuSelection(option: String)
    {
        switch option
        {
            case "Settings & Privacy":
            self.performSegue(withIdentifier: "toSettingsVC", sender: nil)
            case "Logout":
            do
            {
                try Auth.auth().signOut()
                self.performSegue(withIdentifier: "toMemberVC", sender: nil)
            } catch
                {
                print("error")
            }
            default:
                break
            }
        }

    @IBAction func openMenuButtonTapped(_ sender: UIButton)
    {
        // Açılır menüyü oluşturmak için UIAlertController kullanıyoruz.
                let alertController = UIAlertController(title: "Menu", message: "Please select the action you want to take", preferredStyle: .actionSheet)
                // Açılır menüde göstermek istediğiniz seçenekleri ekliyoruz.
                for option in menuOptions {
                    alertController.addAction(UIAlertAction(title: option, style: .default, handler: { (_) in
                        self.handleMenuSelection(option: option)
                    }))
                }
                // Açılır menüyü iptal etme seçeneği ekliyoruz.
                alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                // Açılır menüyü ekranda gösteriyoruz.
                present(alertController, animated: true, completion: nil)
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
    

