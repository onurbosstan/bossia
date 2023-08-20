//
//  HomeVC.swift
//  bossia
//
//  Created by ONUR BOSTAN on 21.07.2023.
//

import UIKit
import Firebase
import SDWebImage



class HomeVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var homeImageView: UIImageView!
    
    let imagePicker = UIImagePickerController()
    
    var userEmailArray = [String]()
    var userCommentArray = [String]()
    var likeArray = [Int]()
    var userImageArray = [String]()
    var documentIdArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        homeImageView.layer.borderWidth = 2.0
        homeImageView.layer.borderColor = UIColor.systemYellow.cgColor

        tableView.dataSource = self
        tableView.delegate = self
        imagePicker.delegate = self
        
        //Karşısına güncel fotoğraf çıkması için;
        if let user = Auth.auth().currentUser
        {
            updateProfilePhoto()
        }
        
        if let member = Auth.auth().currentUser
        {
            getDataFromFirestore()
        }
    }
    func getDataFromFirestore()
    {
        guard let currentUserID = Auth.auth().currentUser?.email else {
            return
        }
        
        let fireStoreDatabase = Firestore.firestore()
        fireStoreDatabase.collection("Post").whereField("email", isEqualTo: currentUserID).order(by: "date", descending: true).addSnapshotListener { (snapshot, error) in
            if error != nil
            {
                self.makeAlert(titleInput: "Error!", messageInput: error?.localizedDescription ?? "Error!")
            } else
            {
                if snapshot?.isEmpty != true && snapshot != nil
                {
                    self.userEmailArray.removeAll(keepingCapacity: false)
                    self.userImageArray.removeAll(keepingCapacity: false)
                    self.userCommentArray.removeAll(keepingCapacity: false)
                    self.likeArray.removeAll(keepingCapacity: false)
                    self.documentIdArray.removeAll(keepingCapacity: false)
        
                    for document in snapshot!.documents
                    {
                        let documentID = document.documentID
                        self.documentIdArray.append(documentID)
                        
                        if let userEmail = document.get("email") as? String
                        {
                            self.userEmailArray.append(userEmail)
                        }
                        if let userComment = document.get("comment") as? String
                        {
                            self.userCommentArray.append(userComment)
                        }
                        if let userLikes = document.get("like") as? Int
                        {
                            self.likeArray.append(userLikes)
                        }
                        if let userImage = document.get("imageurl") as? String
                        {
                            self.userImageArray.append(userImage)
                        }
                    }
                }
                self.tableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return userEmailArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! HomeCell
        cell.emailText.text = userEmailArray[indexPath.row]
        cell.commentLabel.text = userCommentArray[indexPath.row]
        cell.postImageView.sd_setImage(with: URL(string: self.userImageArray[indexPath.row]))
        cell.likeLabel.text = String(likeArray[indexPath.row])
        cell.documentIdLabel.text = documentIdArray[indexPath.row]
        return cell
    }
    
    @IBAction func usersLiked(_ sender: Any)
    {
        performSegue(withIdentifier: "toLikedVC", sender: nil)
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
            } else {
                if let data = data, let profileImage = UIImage(data: data)
                {
                    self.homeImageView.image = profileImage
                }
            }
        }
    }
    
    
    
    @IBAction func searchButtonClicked(_ sender: Any) {
        performSegue(withIdentifier: "toSearchVC", sender: nil)
    }
    
    
    func makeAlert(titleInput: String, messageInput: String)
    {
        let alert = UIAlertController(title: title, message: messageInput, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okButton)
        self.present(alert, animated: true)
    }
}

