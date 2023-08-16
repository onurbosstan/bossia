//
//  PrivacyCell.swift
//  bossia
//
//  Created by ONUR BOSTAN on 15.08.2023.
//

import UIKit

class PrivacyCell: UITableViewCell {
    
    
    @IBOutlet weak var privacyLabel: UILabel!
    @IBOutlet weak var privacyLabel2: UILabel!
    @IBOutlet weak var privacyLabel3: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
