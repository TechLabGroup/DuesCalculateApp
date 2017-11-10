//
//  PartyDetailMember.swift
//  DuesCalculateApp
//
//  Created by TechLab.1 on 2017/09/11.
//  Copyright © 2017年 TechLab. All rights reserved.
//
import Foundation
import RealmSwift

final class PartyDetail: Object {
    dynamic var serialNo: Int = 0 // シリアルNo
    dynamic var partyId = Int() //飲み会ID
    dynamic var name = String()   //参加者
    dynamic var mailAddress = String()  //メールアドレス
    dynamic var paymentCompleteFlag = Int() //支払い完了サイン
    dynamic var paymentAmount = Int()   //支払い金額
    
    //主キー：シリアルNo　（※複数は選択できない）
    override static func primaryKey() -> String? {
        return "serialNo"
    }
    
}
