//
//  SettingsCell.swift
//  bossia
//
//  Created by ONUR BOSTAN on 11.08.2023.
//

import UIKit

class SettingsCell: UITableViewCell {
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var iconBg: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    private func configureUI() {
        iconBg.layer.cornerRadius = 5
        iconBg.clipsToBounds = true
    }
}
