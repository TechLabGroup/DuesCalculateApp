//
//  CustomMemberCell.swift
//  DuesCalculateApp
//
//  Created by TechLab.1 on 2017/09/11.
//  Copyright © 2017年 TechLab. All rights reserved.
//

import UIKit
protocol CustomMemberCellDelegate: class {
    func changeCellColor(swisOn: Bool, memberCell: UIView, memberSerialNo: Int)
}

class CustomMemberCell: UITableViewCell {
    
    weak var delegate: CustomMemberCellDelegate?
    
    // MARK: - IBOutlets
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var memberCell: UIView!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var sw: UISwitch!
    var memberSerialNo: Int!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    
    /// セルの背景色を変更
    ///
    /// - Parameter sender: switch
    @IBAction func changeCellColor(_ sender: UISwitch) {
        delegate?.changeCellColor(swisOn: sender.isOn, memberCell: memberCell, memberSerialNo: memberSerialNo)

    }
    
}
