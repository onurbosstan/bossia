//
//  HomeCell.swift
//  bossia
//
//  Created by ONUR BOSTAN on 21.07.2023.
//

import UIKit
import Firebase

class HomeCell: UITableViewCell {
    
    @IBOutlet weak var emailText: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var documentIdLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    
    var isLiked: Bool = false
    let fireStoreDatabase = Firestore.firestore()
    var db = Firestore.firestore()
    
    let currentUserIDS = Auth.auth().currentUser!.email!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        checkCurrentUserLikeStatus()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func checkCurrentUserLikeStatus() {
        guard let userId = Auth.auth().currentUser?.email,
              let documentId = documentIdLabel.text else
        {
            return
        }
        
        let likesRef = fireStoreDatabase.collection("Posts").document(documentId).collection("like").document(userId)
        
        likesRef.getDocument { (document, error) in
            if let document = document, document.exists
            {
                self.isLiked = true
            } else {
                self.isLiked = false
            }
            self.updateLikeButtonAppearance()
        }
    }
    
    @IBAction func likeButtonClicked(_ sender: Any)
    {
        guard let documentId = documentIdLabel.text else {
                    return
                }

                let likeData: [String: Any] = [
                    "email": Auth.auth().currentUser!.email!,
                    "photoId": documentId,
                    "timestamp": FieldValue.serverTimestamp()
                ]

                db.collection("Likes").addDocument(data: likeData) { error in
                    if let error = error {
                        print("Error adding like data: \(error)")
                    } else {
                        print("Like data added successfully")
                    }
                }

                let incrementValue = isLiked ? 1 : -1
                db.collection("Posts").document(documentId).updateData(["like": FieldValue.increment(Int64(incrementValue))])

                isLiked.toggle()
                updateLikeButtonAppearance()

                updateLikeLabel(increase: !isLiked, decrease: isLiked)
    }
    func updateLikeLabel(increase: Bool = false, decrease: Bool = false) {
            var currentLikeCount = Int(likeLabel.text ?? "0") ?? 0

            if increase {
                currentLikeCount -= 1
            }
            if decrease {
                currentLikeCount += 1
            }

            likeLabel.text = String(currentLikeCount)
        }
    func updateLikeButtonAppearance()
        {
        if isLiked
                {
            let notlikedImage = UIImage(systemName: "heart.fill")
            likeButton.setImage(notlikedImage, for: .normal)
            likeButton.tintColor = UIColor.systemYellow
        } else
            {
            let likedImage = UIImage(systemName: "heart")
            likeButton.setImage(likedImage, for: .normal)
            likeButton.tintColor = UIColor.systemYellow
        }
    }


    @IBAction func deleteButtonClicked(_ sender: Any) {
        let alertController = UIAlertController(title: "Delete Post", message: "Are you sure you want to delete the post?", preferredStyle: .alert)
                let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { (action) in
                    self.confirmDelete()
                }
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                alertController.addAction(deleteAction)
                alertController.addAction(cancelAction)
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
            let viewController = windowScene.windows.first?.rootViewController {
            viewController.present(alertController, animated: true, completion: nil)
        }
    }
    func confirmDelete()
    {
        guard let documentId = documentIdLabel.text else {
            return
        }
        db.collection("Members").document(currentUserIDS).collection("Posts").document(documentId).delete { error in
            if let error = error
            {
                print("Error deleting post: \(error)")
            } else
            {
                print("Post successfully deleted")
                let photoStorageRef = Storage.storage().reference().child("media").child("\(documentId).jpg")
                photoStorageRef.delete { error in
                    if let error = error
                    {
                        print("Error deleting photo: \(error)")
                    } else
                    {
                        print("Photo deleted successfully")
                    }
                }
                NotificationCenter.default.post(name: Notification.Name("PostDeleted"), object: nil)
            }
        }
    }
}
