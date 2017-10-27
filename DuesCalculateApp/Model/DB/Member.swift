//
//  PartyDetailMember.swift
//  DuesCalculateApp
//
//  Created by TechLab.1 on 2017/09/11.
//  Copyright © 2017年 TechLab. All rights reserved.
//

import RealmSwift

final class Member: Object {
    /// シリアルNo
    dynamic var serialNo: Int = 0
    /// 飲み会ID
    dynamic var partyId: Int = 0
    /// 参加者
    dynamic var memberName: String = ""
    /// メールアドレス
    dynamic var mailAddress: String = ""
    /// 支払い完了フラグ
    dynamic var paymentCompleteFlag: Bool = false
    /// 支払い金額
    dynamic var paymentAmount: Int = 0
    
    //主キー：飲み会ID　（※複数は選択できない）
    override static func primaryKey() -> String? {
        return "serialNo"
    }
    
}
