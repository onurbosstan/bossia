//
//  likedUserCell.swift
//  bossia
//
//  Created by ONUR BOSTAN on 27.07.2023.
//

import UIKit

class likedUserCell: UITableViewCell {
    
    @IBOutlet weak var mailLabel: UILabel!
    @IBOutlet weak var commentsLabel: UILabel!
    @IBOutlet weak var postsImageView: UIImageView!
    @IBOutlet weak var documentLabel: UILabel!
    @IBOutlet weak var likesLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        postsImageView.layer.borderWidth = 0.5
        postsImageView.layer.borderColor = UIColor.systemYellow.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
