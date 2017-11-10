//
//  DBManager.swift
//  DuesCalculateApp
//
//  Copyright © 2017年 TechLab. All rights reserved.
//

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
    
    /// メンバー登録
    ///
    /// - Parameters:
    ///   - partyId: 対象の飲み会ID
    ///   - memberName: 飲み会参加者名
    ///   - mailAddress: 飲み会参加者メールアドレス
    ///   - paymentCompleteFlag: 支払い完了フラグ
    ///   - paymentAmount: 支払い額
    /// - Returns: 登録結果
    public static func entryMember(partyId: Int, memberName: String, mailAddress: String, paymentCompleteFlag: Bool, paymentAmount: Int) -> Bool {
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
    
    /// メンバー削除
    ///
    /// - Parameter partyId: 削除結果
    public static func deleteMember(serialNo: Int) {
        let realm = try! Realm()
        let member = realm.objects(Member.self).filter("serialNo == %@", serialNo)
        
        try! realm.write {
            realm.delete(member)
        }
    }
    
    /// 飲み会IDのインクリメント
    ///
    /// - Returns: インクリメント結果
    private static func incrementID() -> Int {
        let realm = try! Realm()
        return (realm.objects(Party.self).max(ofProperty: "partyId") as Int? ?? 0) + 1
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
    public static func searchParty(partyId: Int) -> Party {
        let realm = try! Realm()
        let party = realm.objects(Party.self).filter("partyId == %@", partyId)
        return party[0]
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
    
    /// 参加者オブジェクト作成
    ///
    /// - Parameters:
    ///   - partyId: 飲み会ID
    ///   - name: 参加者
    ///   - mailAddress: メールアドレス
    ///   - amount: 金額
    /// - Returns: 登録結果
    public static func createPartyDetail(partyId: Int, name: String, mailAddress: String, amount: Int) -> Bool {
        let realm = try! Realm()
        
        let partyDetail = PartyDetail()
        partyDetail.serialNo = incrementNo()
        partyDetail.partyId = partyId
        partyDetail.name = name
        partyDetail.mailAddress = mailAddress
        partyDetail.paymentCompleteFlag = 0
        partyDetail.paymentAmount = amount
        
        try! realm.write {
            realm.add(partyDetail)
        }
        return true
    }
    
    /// シリアルNoのインクリメント
    ///
    /// - Returns: インクリメント結果
    private static func incrementNo() -> Int {
        let realm = try! Realm()
        return (realm.objects(PartyDetail.self).max(ofProperty: "serialNo") as Int? ?? 0) + 1
    }
    
    /// 参加者検索
    ///
    /// - Parameter serialNo: 対象のシリアルNo
    /// - Returns: 該当する参加者
    public static func searchMember(serialNo: Int) -> [PartyDetail] {
        let realm = try! Realm()
        let party = realm.objects(PartyDetail.self).filter("serialNo == %@", serialNo)
        return Array(party)
    }
    
    /// 参加者更新
    ///
    /// - Parameters:
    ///   - serialNo: 対象のシリアルNo
    ///   - amount: 金額
    /// - Returns: 更新結果
    public static func updateMember(serialNo: Int, amount: Int) -> Bool {
        let realm = try! Realm()
        let member = realm.objects(PartyDetail.self).filter("serialNo == %@", serialNo)
        if let update = member.first {
            try! realm.write {
                update.paymentAmount = amount
            }
            return true
        }
        return false
    }
    
    /// 飲み会名称検索
    ///
    /// - Parameter partyId: 対象飲み会ID
    /// - Returns: 対象飲み会名称
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
    /// - Parameter partyId: 対象飲み会ID
    /// - Returns: 対象飲み会参加者一覧
    public static func searchAllMember(partyId: Int) -> [Member] {
        let realm = try! Realm()
        let member = realm.objects(Member.self).filter("partyId == %@", partyId)
        return Array(member)
    }
    
    
    /// 支払い完了フラグ更新
    ///
    /// - Parameters:
    ///   - partyId: 飲み会ID
    ///   - paymentCompleteFlag: 支払い完了フラグ
    /// - Returns: 支払い完了結果
    public static func updatePaymentCompFlg(serialNo: Int, partyId: Int, paymentCompleteFlag: Bool) {
        let realm = try! Realm()
        let party = realm.objects(Member.self).filter("serialNo = %@ && partyId == %@", serialNo, partyId)
        if let update = party.first {
            try! realm.write {
                update.paymentCompleteFlag = paymentCompleteFlag
            }
        }
    }
}
