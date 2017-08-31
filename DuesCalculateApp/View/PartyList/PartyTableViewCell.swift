//
//  PartyTableViewCell.swift
//  DuesCalculateApp
//
//  Created by TechLab.5 on 2017/08/31.
//  Copyright © 2017年 TechLab. All rights reserved.
//

import UIKit

class PartyTableViewCell: UITableViewCell {
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var partyName: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
