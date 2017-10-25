//
//  CustomMemberCell.swift
//  DuesCalculateApp
//
//  Created by TechLab.1 on 2017/09/11.
//  Copyright © 2017年 TechLab. All rights reserved.
//

import UIKit
protocol cellaction {
    func changeCellColor(swisOn: Bool, memberCell: UIView)
}

class CustomMemberCell: UITableViewCell {
    
    var delegate: cellaction!
    
    // MARK: - IBOutlets
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var memberCell: UIView!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var sw: UISwitch!
    

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    
    /// セルの背景色を変更
    ///
    /// - Parameter sender: <#sender description#>
    @IBAction func changeCellColor(_ sender: UISwitch) {
        let swisOn: Bool = sw.isOn
        delegate.changeCellColor(swisOn: swisOn, memberCell: memberCell)

    }
    
}
