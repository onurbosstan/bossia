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

}
