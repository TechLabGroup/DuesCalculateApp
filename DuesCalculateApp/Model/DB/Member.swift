//
//  PartyDetailMember.swift
//  DuesCalculateApp
//
//  Created by TechLab.1 on 2017/09/11.
//  Copyright © 2017年 TechLab. All rights reserved.
//

import Foundation
import RealmSwift

final class Member: Object {
    dynamic var serialNo: Int = 0 // シリアルNo
    dynamic var partyId: Int = 0 //飲み会ID
    dynamic var memberName: String = ""   //参加者
    dynamic var mailAddress: String = ""  //メールアドレス
    dynamic var paymentCompleteFlag: Bool = false //支払い完了フラグ
    dynamic var paymentAmount: Int = 0   //支払い金額
    
    //主キー：飲み会ID　（※複数は選択できない）
    override static func primaryKey() -> String? {
        return "serialNo"
    }
    
}
