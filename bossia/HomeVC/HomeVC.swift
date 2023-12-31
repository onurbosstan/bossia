//
//  HomeVC.swift
//  bossia
//
//  Created by ONUR BOSTAN on 21.07.2023.
//

import UIKit
import Firebase
import SDWebImage

class HomeVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITabBarControllerDelegate {

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
        
        self.tabBarController?.delegate = self
        
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
        NotificationCenter.default.addObserver(self, selector: #selector(postDeleted), name: NSNotification.Name("PostDeleted"), object: nil)
    }
    @objc func postDeleted() {
        getDataFromFirestore()
    }

    func getDataFromFirestore()
    {
        guard let currentUserID = Auth.auth().currentUser?.email! else
        {
            return
        }
        let fireStoreDatabase = Firestore.firestore()
        fireStoreDatabase.collection("Members").document(currentUserID).collection("Posts").order(by: "date", descending: true).addSnapshotListener { (snapshot, error) in
            if error != nil
            {
                self.makeAlert(titleInput: "Error!", messageInput: error?.localizedDescription ?? "Error!")
            } else
            {
                if let snapshot = snapshot
                {
                    self.userEmailArray.removeAll()
                    self.userImageArray.removeAll()
                    self.userCommentArray.removeAll()
                    self.likeArray.removeAll()
                    self.documentIdArray.removeAll()

                    for document in snapshot.documents
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
                    self.tableView.reloadData()
                }
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
        
        let documentId = documentIdArray[indexPath.row]
                let likesRef = Firestore.firestore().collection("Posts").document(documentId).collection("like").document(Auth.auth().currentUser!.email!)
                
                likesRef.getDocument { (document, error) in
                    if let document = document, document.exists {
                        cell.isLiked = true
                    } else {
                        cell.isLiked = false
                    }
                    cell.updateLikeButtonAppearance()
                }
        return cell
    }
    
    //Beğenenler
    @IBAction func usersLiked(_ sender: Any)
    {
        performSegue(withIdentifier: "toLikedVC", sender: nil)
    }

    
    //Profil Fotoğrafı
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
                if let data = data, let profileImage = UIImage(data: data)
                {
                    self.homeImageView.image = profileImage
                }
            }
        }
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if viewController is HomeVC {
            scrollToTop()
        }
    }
    func scrollToTop() {
        let indexPath = IndexPath(row: 0, section: 0)
        self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
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

