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
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
    @IBAction func likeButtonClicked(_ sender: Any)
    {
        let fireStoreDatabase = Firestore.firestore()
        if let likeCount = Int(likeLabel.text!)
        {
            let likeStore = ["like" : likeCount + 1] as [String : Any]
            fireStoreDatabase.collection("Post").document(documentIdLabel.text!).setData(likeStore, merge: true)
        }
        
    }
    
    @IBAction func deleteButtonClicked(_ sender: Any) {
        let postIdToDelete = Auth.auth().currentUser!.email!
        deletePost(postId: postIdToDelete)
        
    }
    func deletePost(postId: String) {
        let fireStoreDatabase = Firestore.firestore()
        fireStoreDatabase.collection("Post").document(documentIdLabel.text!).delete { (error) in
            if error != nil {
                let alert = UIAlertController(title: "Error!", message: error?.localizedDescription ?? "Error!", preferredStyle: .alert)
                let okButton = UIAlertAction(title: "Error!", style: .default)
                alert.addAction(okButton)
            } else {
                print("Success!")
            }
        }
    }
    
}
