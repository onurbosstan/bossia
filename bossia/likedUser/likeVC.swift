//
//  likedUserVC.swift
//  bossia
//
//  Created by ONUR BOSTAN on 26.07.2023.
//

import UIKit
import Firebase
import SDWebImage

class likeVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var documentIDArray = [String]()
    var userProfileImageArray = [String]()
    var userMailArray = [String]()
    var commentLabelArray = [String]()
    var postImageArray = [String]()
    var db = Firestore.firestore()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "likeCell", bundle: nil), forCellReuseIdentifier: "likeCell")
        
        getLiked()
    }
    func getLiked()
    {
        db.collection("Likes").order(by: "timestamp", descending: true).addSnapshotListener { (snapshot, error) in
            if error != nil
            {
                self.makeAlert(titleInput: "Error!", messageInput: error?.localizedDescription ?? "Error!")
            } else
            {
                if snapshot?.isEmpty != true && snapshot != nil
                {
                    self.userMailArray.removeAll(keepingCapacity: false)
                    self.documentIDArray.removeAll(keepingCapacity: false)
                    self.postImageArray.removeAll(keepingCapacity: false)
                    
                    for document in snapshot!.documents
                    {
                        let documentID = document.documentID
                        self.documentIDArray.append(documentID)
                        
                        if let userEmail = document.get("email") as? String
                        {
                            self.userMailArray.append(userEmail)
                        }
                        if let userImage = document.get("photoId") as? String
                        {
                            self.postImageArray.append(userImage)
                        }
                    }
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userMailArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "likeCell", for: indexPath) as! likeCell
        cell.userEmailLabel.text = userMailArray[indexPath.row]
        cell.postImageView.sd_setImage(with: URL(string: self.postImageArray[indexPath.row]))
        cell.documentIDLabel.text = documentIDArray[indexPath.row]
        return cell
    }
    func makeAlert(titleInput: String, messageInput: String)
    {
        let alert = UIAlertController(title: title, message: messageInput, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okButton)
        self.present(alert, animated: true)
    }
}
