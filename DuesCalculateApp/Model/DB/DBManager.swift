//
//  DBManager.swift
//  DuesCalculateApp
//
//  Copyright © 2017年 TechLab. All rights reserved.
//

import Foundation
import RealmSwift

final class DBManager {
    
    /// 飲み会オブジェクト作成
    ///
    /// - Parameters:
    ///   - partyName: 飲み会名
    ///   - partyDate: 日付
    ///   - totalAmount: 金額
    /// - Returns: 登録結果
    public static func createParty(partyName: String, partyDate: String, totalAmount: Int) -> Bool {
        let realm = try! Realm()
        
        let party = Party()
        party.partyId = incrementID()
        party.partyName = partyName
        party.date = partyDate
        party.totalAmount = totalAmount
        
        try! realm.write {
            realm.add(party)
        }
        return true
    }
    
    
    /// 飲み会IDのインクリメント
    ///
    /// - Returns: インクリメント結果
    private static func incrementID() -> Int {
    let realm = try! Realm()
    return (realm.objects(Party.self).max(ofProperty: "partyId") as Int? ?? 0) + 1
    }
    
    /// メンバー登録
    ///
    /// - Parameters:
    ///   - partyId: <#partyId description#>
    ///   - memberName: <#memberName description#>
    ///   - mailAddress: <#mailAddress description#>
    ///   - paymentCompleteFlag: <#paymentCompleteFlag description#>
    ///   - paymentAmount: <#paymentAmount description#>
    /// - Returns: <#return value description#>
    public static func entryMember(partyId: Int, memberName: String, mailAddress: String, paymentCompleteFlag: Int, paymentAmount: Int) -> Bool {
        let realm = try! Realm()
        
        let member = Member()
        member.partyId = partyId
        member.memberName = memberName
        member.mailAddress = mailAddress
        member.paymentCompleteFlag = paymentCompleteFlag
        member.paymentAmount = paymentAmount
        
        try! realm.write {
            realm.add(member)
        }
        return true
    }

    
    /// 飲み会一覧検索
    ///
    /// - Returns: 全ての飲み会リスト
    public static func searchParty() -> [Party] {
        let realm = try! Realm()
        let party = realm.objects(Party.self)
        return Array(party)
    }
    
    //// 飲み会検索
    ///
    /// - Parameter partyId: 対象の飲み会ID
    /// - Returns: 該当する飲み会
    public static func searchParty(partyId: Int) -> [Party] {
        let realm = try! Realm()
        let party = realm.objects(Party.self).filter("partyId == %@", partyId)
        return Array(party)
    }
    

    
    /// 飲み会削除
    ///
    /// - Parameter partyId: 対象の飲み会ID
    public static func deleteParty(partyId: Int) {
        let realm = try! Realm()
        let party = realm.objects(Party.self).filter("partyId == %@", partyId)
        try! realm.write {
            realm.delete(party)
        }
        
    }
    
    
    /// 飲み会更新
    ///
    /// - Parameters:
    ///   - partyId: 対象の飲み会ID
    ///   - partyName: 飲み会名
    ///   - partyDate: 日付
    ///   - totalAmount: 金額
    /// - Returns: 更新結果
    public static func updateParty(partyId: Int, partyName: String, partyDate: String, totalAmount: Int) -> Bool {
        let realm = try! Realm()
        let party = realm.objects(Party.self).filter("partyId == %@", partyId)
        if let update = party.first {
            try! realm.write {
                update.partyName = partyName
                update.date = partyDate
                update.totalAmount = totalAmount
            }
            return true
        }
        return false
    }

    
    /// 飲み会名称検索
    ///
    /// - Parameter partyId: <#partyId description#>
    /// - Returns: <#return value description#>
    public static func searchPartyName(partyId: Int) -> String {
        let realm = try! Realm()
        let party = realm.objects(Party.self).filter("partyId == %@", partyId)
        var partyName = ""
        for name in party {
            partyName = name.partyName
        }
        return partyName
    }
    
    /// 飲み会参加者一覧検索
    ///
    /// - Parameter partyId: <#partyId description#>
    /// - Returns: <#return value description#>
    public static func searchAllMember(partyId: Int) -> [Member] {
        let realm = try! Realm()
        let member = realm.objects(Member.self).filter("partyId == %@", partyId)
        return Array(member)
    }
    
    
    /// 支払い完了フラグに更新
    ///
    /// - Parameters:
    ///   - partyId: <#partyId description#>
    ///   - memberName: <#memberName description#>
    ///   - paymentCompleteFlag: <#paymentCompleteFlag description#>
    public static func updateMemberFinish(partyId: Int, memberName: String, paymentCompleteFlag: Int) {
        let realm = try! Realm()
        let member = realm.objects(Member.self).filter("memberName = %@ && partyId == %@", memberName, partyId).first
        try! realm.write ({ () -> Void in
            member?.paymentCompleteFlag = 1 })
    }
    
    /// 支払い完了フラグを解除
    ///
    /// - Parameters:
    ///   - partyId: <#partyId description#>
    ///   - memberName: <#memberName description#>
    ///   - paymentCompleteFlag: <#paymentCompleteFlag description#>
    public static func repositupdateMember(partyId: Int, memberName: String, paymentCompleteFlag: Int) {
        let realm = try! Realm()
        let member = realm.objects(Member.self).filter("memberName = %@ && partyId == %@", memberName, partyId).first
        try! realm.write ({ () -> Void in
            member?.paymentCompleteFlag = 0 })
    }
    
    /// 支払い完了フラグ更新
    ///
    /// - Parameters:
    ///   - partyId: 飲み会ID
    ///   - paymentCompleteFlag: 支払い完了フラグ
    /// - Returns: return value description
    public static func updatePaymentCompFlg(partyId: Int, paymentCompleteFlag: Int) -> Bool {
        let realm = try! Realm()
        let party = realm.objects(Member.self).filter("partyId == %@", partyId)
        if let update = party.first {
            try! realm.write {
                if paymentCompleteFlag == 0 {
                    update.paymentCompleteFlag = 1
                } else {
                    update.paymentCompleteFlag = 0
                }
            }
            return true
        }
        return false
    }
    

    
}
