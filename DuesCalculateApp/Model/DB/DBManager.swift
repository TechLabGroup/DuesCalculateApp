//
//  DBManager.swift
//  DuesCalculateApp
//
//  Copyright © 2017年 TechLab. All rights reserved.
//

import Foundation
import RealmSwift

final class DBManager {
    
    /// <#Description#>
    /// 飲み会作成
    ///
    /// - Parameters:
    ///   - partyName: <#partyName description#>
    ///   - partyDate: <#partyDate description#>
    ///   - totalAmount: <#totalAmount description#>
    /// - Returns: <#return value description#>
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
    
    /// <#Description#>
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
    
    /// <#Description#>
    /// partyIdのシーケンス
    ///
    /// - Returns: <#return value description#>
    private static func incrementID() -> Int {
        let realm = try! Realm()
        return (realm.objects(Party.self).max(ofProperty: "partyId") as Int? ?? 0) + 1
    }
    
    /// <#Description#>
    /// 飲み会一覧検索
    ///
    /// - Returns: <#return value description#>
    public static func searchParty() -> [Party] {
        let realm = try! Realm()
        let party = realm.objects(Party.self)
        return Array(party)
    }
    
    /// <#Description#>
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
    
    /// <#Description#>
    /// 飲み会参加者一覧検索
    ///
    /// - Parameter partyId: <#partyId description#>
    /// - Returns: <#return value description#>
    public static func searchAllMember(partyId : Int) -> [Member] {
        let realm = try! Realm()
        let member = realm.objects(Member.self).filter("partyId == %@", partyId)
        return Array(member)
    }
    
    
    /// <#Description#>
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
    
    /// <#Description#>
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
    
    //合計金額

    
    //集計金額
    
    //残り人数
    
}
