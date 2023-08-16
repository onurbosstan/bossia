//
//  likeCell.swift
//  bossia
//
//  Created by ONUR BOSTAN on 13.08.2023.
//

import UIKit
import Firebase

class likeCell: UITableViewCell {
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userEmailLabel: UILabel!
    @IBOutlet weak var likePostLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var documentIDLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        userImageView.layer.borderWidth = 2.0
        userImageView.layer.borderColor = UIColor.systemYellow.cgColor
        
        updateProfilePhoto()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
    
    func updateProfilePhoto()
    {
        guard let userID = Auth.auth().currentUser?.email else {
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
                    self.userImageView.image = profileImage
                }
            }
        }
    }
    
}
