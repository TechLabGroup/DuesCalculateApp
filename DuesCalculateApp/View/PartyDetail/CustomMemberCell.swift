//
//  CustomMemberCell.swift
//  DuesCalculateApp
//
//  Created by TechLab.1 on 2017/09/11.
//  Copyright © 2017年 TechLab. All rights reserved.
//

import UIKit

class CustomMemberCell: UITableViewCell  {

    
    // MARK: - IBOutlets
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var memberCell: UIView!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var sw: UISwitch!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    /// <#Description#>
    /// セルの背景色を変更
    ///
    /// - Parameter sender: <#sender description#>
    @IBAction func changeCellColor(_ sender: UISwitch) {
        if sw.isOn {
            memberCell.backgroundColor = UIColor.gray
        } else {
            memberCell.backgroundColor = UIColor.white
        }
        
    }
    

//    
//    /// <#Description#>
//    ///
//    ///
//    /// - Parameters:
//    ///   - selected: <#selected description#>
//    ///   - animated: <#animated description#>
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }
    
}
