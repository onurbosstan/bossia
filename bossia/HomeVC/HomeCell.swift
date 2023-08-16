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
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func checkCurrentUserLikeStatus() {
        guard let userId = Auth.auth().currentUser?.email,
              let documentId = documentIdLabel.text else {
            return
        }
        
        let likesRef = fireStoreDatabase.collection("Post").document(documentId).collection("like").document(userId)
        
        likesRef.getDocument { (document, error) in
            if let document = document, document.exists {
                self.isLiked = true
            } else {
                self.isLiked = false
            }
            self.updateLikeButtonAppearance()
        }
    }
    
    @IBAction func likeButtonClicked(_ sender: Any)
    {
        guard let documentId = documentIdLabel.text else
        {
                    return
                }
                
            let likeData: [String: Any] = [
            "email": Auth.auth().currentUser!.email!,
            "photoId": documentId,
            "timestamp": FieldValue.serverTimestamp()
            ]
            
            db.collection("Likes").addDocument(data: likeData) { error in
                if let error = error
                {
                    print("Beğeni verisi eklenirken hata oluştu: \(error)")
                } else {
                    print("Beğeni verisi başarıyla eklendi")
                }
                }
                if isLiked
                {
                    fireStoreDatabase.collection("Post").document(documentId).updateData(["like": FieldValue.increment(Int64(-1))])
                } else
                {
                    fireStoreDatabase.collection("Post").document(documentId).updateData(["like": FieldValue.increment(Int64(1))])
                }
                isLiked.toggle()
                updateLikeButtonAppearance()
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
        let postIdToDelete = Auth.auth().currentUser!.email!
        deletePost(postId: postIdToDelete)
        
    }
    func deletePost(postId: String)
    {
        let fireStoreDatabase = Firestore.firestore()
        fireStoreDatabase.collection("Post").document(documentIdLabel.text!).delete { (error) in
            if error != nil
            {
                let alert = UIAlertController(title: "Error!", message: error?.localizedDescription ?? "Error!", preferredStyle: .alert)
                let okButton = UIAlertAction(title: "Error!", style: .default)
                alert.addAction(okButton)
            } else {
                print("Success!")
            }
        }
    }
}
