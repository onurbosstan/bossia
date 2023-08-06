//
//  likedUserVC.swift
//  bossia
//
//  Created by ONUR BOSTAN on 26.07.2023.
//

import UIKit
import Firebase
import SDWebImage

class likedUserVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var likedTableView: UITableView!

    var userEmailsArray = [String]()
    var userCommentsArray = [String]()
    var userImagesArray = [String]()
    var documentsIdArray = [String]()
    var likesArray = [Int]()
  

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        likedTableView.dataSource = self
        likedTableView.delegate = self
        
        getLikedData()
        //getDataFromFirestore()
    }
    func getLikedData() {
        let db = Firestore.firestore()
        db.collection("Post").order(by: "date",descending: true).addSnapshotListener { (querySnapshot, error) in
            guard let snapshot = querySnapshot else {
                self.makeAlert(titleInput: "Error!", messageInput: error?.localizedDescription ?? "Error")
                return
            }
            for document in snapshot.documents {
                let documentID = document.documentID
                self.documentsIdArray.append(documentID)
                
                if let usersEmail = document.get("email") as? String
                {
                    self.userEmailsArray.append(usersEmail)
                }
                if let usersImage = document.get("imageurl") as? String
                {
                    self.userImagesArray.append(usersImage)
                }
            }
        }
        self.likedTableView.reloadData()
    }
    
    /*
    func getDataFromFirestore()
    {
        let fireStoreDatabase = Firestore.firestore()
        fireStoreDatabase.collection("Post").order(by: "date", descending: true).addSnapshotListener { (snapshot, error) in
            if error != nil
            {
                self.makeAlert(titleInput: "Error!", messageInput: error?.localizedDescription ?? "Error!")
            } else
            {
                if snapshot?.isEmpty != true && snapshot != nil
                {
                    self.userEmailsArray.removeAll(keepingCapacity: false)
                    self.userImagesArray.removeAll(keepingCapacity: false)
                    self.userCommentsArray.removeAll(keepingCapacity: false)
                    self.documentsIdArray.removeAll(keepingCapacity: false)
                    
                    
                    for document in snapshot!.documents
                    {
                        let documentID = document.documentID
                        self.documentsIdArray.append(documentID)
                        
                        if let userEmail = document.get("email") as? String
                        {
                            self.userEmailsArray.append(userEmail)
                        }
                        if let userComment = document.get("comment") as? String
                        {
                            self.userCommentsArray.append(userComment)
                        }
                        if let userImage = document.get("imageurl") as? String
                        {
                            self.userImagesArray.append(userImage)
                        }
                        if let userLikes = document.get("like") as? Int
                        {
                            self.likesArray.append(userLikes)
                        }

                    }
                }
                self.likedTableView.reloadData()
            }
        }
    }
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userEmailsArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = likedTableView.dequeueReusableCell(withIdentifier: "Cell2", for: indexPath) as! likedUserCell
        cell.mailLabel.text = userEmailsArray[indexPath.row]
        //cell.commentsLabel.text = "gönderinizi beğendi\(userCommentsArray[indexPath.row])"
        cell.postsImageView.sd_setImage(with: URL(string: self.userImagesArray[indexPath.row]))
        cell.documentLabel.text = documentsIdArray[indexPath.row]
        //cell.likesLabel.text = String(likesArray[indexPath.row])
        return cell
    }
  
 
    
 
    func makeAlert(titleInput: String, messageInput: String)
    {
        let alert = UIAlertController(title: title, message: messageInput, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "YES", style: .default)
        alert.addAction(okButton)
        self.present(alert, animated: true)
    }
}
