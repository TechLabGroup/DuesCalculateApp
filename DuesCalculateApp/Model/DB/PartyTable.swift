//
//  PartyTable.swift
//  DuesCalculateApp
//
//  Created by Tanino-Sato on 2017/08/10.
//  Copyright © 2017年 TechLab. All rights reserved.
//

import Foundation
import RealmSwift

final class PartyTable: Object {
    dynamic var partyId = Int() //飲み会ID
    dynamic var partyName  = String() //飲み会名
//    dynamic var date  = Date() //開催日
    dynamic var totalAmount = Int() //合計金額
    
    //主キーに飲み会IDを設定
    override static func primaryKey() -> String? {
        return "partyId"
    }
}
