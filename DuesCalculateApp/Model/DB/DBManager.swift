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
    
    
    /// 飲み会一覧検索
    ///
    /// - Returns: 全ての飲み会リスト
    public static func searchParty() -> [Party] {
        let realm = try! Realm()
        let party = realm.objects(Party.self)
        return Array(party)
    }
    
    
    /// 飲み会検索
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
        
        let partyDetail = PartyDetailMember()
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
        return (realm.objects(PartyDetailMember.self).max(ofProperty: "serialNo") as Int? ?? 0) + 1
    }
    
    /// 参加者検索
    ///
    /// - Parameter serialNo: 対象のシリアルNo
    /// - Returns: 該当する参加者
    public static func searchMember(serialNo: Int) -> [PartyDetailMember] {
        let realm = try! Realm()
        let party = realm.objects(PartyDetailMember.self).filter("serialNo == %@", serialNo)
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
        let member = realm.objects(PartyDetailMember.self).filter("serialNo == %@", serialNo)
        if let update = member.first {
            try! realm.write {
                update.paymentAmount = amount
            }
            return true
        }
        return false
    }
    
}
