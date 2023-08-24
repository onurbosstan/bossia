//
//  MemberVC.swift
//  bossia
//
//  Created by ONUR BOSTAN on 20.08.2023.
//

import UIKit
import Firebase
import SDWebImage

struct Post {
    let email: String
    let imageUrl: String
}

class MemberVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var userProfilePhoto: UIImageView!
    @IBOutlet weak var userEmailLabel: UILabel!
    @IBOutlet weak var postNumberLabel: UILabel!
    @IBOutlet weak var followersNumberLabel: UILabel!
    @IBOutlet weak var followingNumberLabel: UILabel!
    
    var membersEmailArray = [String]()
    var membersImageArray = [String]()
    var membersDocumentArray = [String]()
    
    var selectedUserEmail: String?
    var userPosts: [Post] = []
    var selectedUserEmails: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userProfilePhoto.layer.borderWidth = 2.0
        userProfilePhoto.layer.borderColor = UIColor.systemYellow.cgColor
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.collectionViewLayout = UICollectionViewFlowLayout()
        collectionView.collectionViewLayout = CollectionLayout(colmnsNumber: 3, minColmnsNumber: 1, minCell: 1)
        
        if let userEmail = selectedUserEmail {
                updateUserProfilePhoto(userEmail: userEmail)
                updateUserEmailLabel(email: userEmail)
            }
        
        loadUserPosts()
    }
    func loadUserPosts()
    {
        guard let userEmail = selectedUserEmail else
        {
            return
        }
        
        let firestoreDatabase = Firestore.firestore()
        let postsCollection = firestoreDatabase.collection("Members").document(userEmail).collection("Posts")
        
        postsCollection.getDocuments { (querySnapshot, error) in
            if let error = error
            {
                print("Error loading user posts: \(error.localizedDescription)")
                return
            }
            
            guard let documents = querySnapshot?.documents else { return }
            
            self.userPosts = documents.compactMap { document in
                let data = document.data()
                let email = data["email"] as? String ?? ""
                let imageUrl = data["imageurl"] as? String ?? ""
                
                return Post(email: email, imageUrl: imageUrl)
            }
            
            self.reloadPage()
        }
    }
    private func reloadPage()
    {
        self.collectionView.reloadData()
        self.postNumberLabel.text = "\(self.userPosts.count)"
    }

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userPosts.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemberCell", for: indexPath) as! MemberCell
        let post = userPosts[indexPath.row]
        cell.collectionImageView.sd_setImage(with: URL(string: post.imageUrl))
        return cell
    }
    
    func updateUserEmailLabel(email: String)
    {
        userEmailLabel.text = email
    }
    
    func updateUserProfilePhoto(userEmail: String) {
        let storageRef = Storage.storage().reference().child("profilePhoto").child("\(userEmail).jpg")
        storageRef.getData(maxSize: 1 * 1024 * 1024) { (data, error) in
            if let error = error {
                print("Error fetching user profile photo: \(error.localizedDescription)")
            } else if let data = data, let profileImage = UIImage(data: data) {
                self.userProfilePhoto.image = profileImage
            }
        }
    }
    
    @IBAction func followButtonClicked(_ sender: Any) {
        
    }
    
    @IBAction func backToSearchBar(_ sender: Any) {
        performSegue(withIdentifier: "backToSearch", sender: nil)
    }
    func makeAlert(titleInput: String, messageInput: String)
    {
        let alert = UIAlertController(title: title, message: messageInput, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okButton)
        self.present(alert, animated: true)
    }
}
