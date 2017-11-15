//
//  TableViewCell.swift
//  DuesCalculateApp
//
//  Created by TechLanb.4 on 2017/09/15.
//  Copyright © 2017年 TechLab. All rights reserved.
//

import UIKit

class MemberTableViewCell: UITableViewCell {
    @IBOutlet weak var name: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
