//
//  DBManager.swift
//  DuesCalculateApp
//
//  Copyright © 2017年 TechLab. All rights reserved.
//

import RealmSwift

final class DBManager {
    
    // MARK: - Create
    
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
        party.partyId = incrementPartyID()
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
        member.serialNo = incrementSerialNo()
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
    
    // MARK: - Read
    
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
    
    /// 参加者検索(シリアルNo指定)
    ///
    /// - Parameter serialNo: 対象のシリアルNo
    /// - Returns: 該当する参加者
    public static func searchMemberBySerialNo(serialNo: Int) -> Member {
        let realm = try! Realm()
        let member = realm.objects(Member.self).filter("serialNo == %@", serialNo)
        
        return member.isEmpty ? Member() : member[0]
    }
    
    /// 参加者検索(飲み会ID指定)
    ///
    /// - Parameter partyId: 対象の飲み会ID
    /// - Returns: 該当する参加者一覧
    public static func searchMemberByPartyId(partyId: Int) -> [Member] {
        let realm = try! Realm()
        let members = realm.objects(Member.self).filter("partyId == %@", partyId)
        
        return Array(members)
    }
    
    // MARK: - Update
    
    /// 飲み会IDのインクリメント
    ///
    /// - Returns: インクリメント結果
    private static func incrementPartyID() -> Int {
        let realm = try! Realm()
        return (realm.objects(Party.self).max(ofProperty: "partyId") as Int? ?? 0) + 1
    }
  
    /// シリアルNoのインクリメント
    ///
    /// - Returns: インクリメント結果
    private static func incrementSerialNo() -> Int {
        let realm = try! Realm()
        return (realm.objects(Member.self).max(ofProperty: "serialNo") as Int? ?? 0) + 1
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
    
    /// 参加者更新
    ///
    /// - Parameters:
    ///   - serialNo: 対象のシリアルNo
    ///   - amount: 金額
    /// - Returns: 更新結果
    public static func updateMember(serialNo: Int, amount: Int) -> Bool {
        let realm = try! Realm()
        let member = realm.objects(Member.self).filter("serialNo == %@", serialNo)
        if let update = member.first {
            try! realm.write {
                update.paymentAmount = amount
            }
            return true
        }
        return false
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
    
    // MARK: - Delete
    
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
}
