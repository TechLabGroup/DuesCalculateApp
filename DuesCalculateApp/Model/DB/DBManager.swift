//
//  DBManager.swift
//  DuesCalculateApp
//
//  Copyright © 2017年 TechLab. All rights reserved.
//

import Foundation
import RealmSwift

final class DBManager {
    
    // 飲み会作成
    public func createParty(partyName: String, partyDate: String, totalAmount: Int) -> Bool {
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
    
    func incrementID() -> Int {
    private static func incrementID() -> Int {
        let realm = try! Realm()
        return (realm.objects(Party.self).max(ofProperty: "partyId") as Int? ?? 0) + 1
    }
    
    public func searchParty() -> [Party] {
    public static func searchParty() -> [Party] {
        let realm = try! Realm()
        let party = realm.objects(Party.self)
        return Array(party)
    }
    
    public func deleteParty(partyId: Int) {
    public static func deleteParty(partyId: Int) {
        let realm = try! Realm()
        let party = realm.objects(Party.self).filter("partyId == %@", partyId)
        try! realm.write {
            realm.delete(party[partyId])
            realm.delete(party)
        }
        
    }
    
}
