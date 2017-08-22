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
        let realm = try! Realm()
        
        let party = Party()
        party.partyId = incrementID()
        party.partyName = partyName
        party.date = partyDate
        party.totalAmount = totalAmount
        
        try! realm.write() {
            realm.add(party)
        }
        return true
    }
    
    func incrementID() -> Int {
        let realm = try! Realm()
        return (realm.objects(Party.self).max(ofProperty: "partyId") as Int? ?? 0) + 1
    }
    
    public func getNumberOfParties() -> Int {
        let realm = try! Realm()
        let party = realm.objects(Party.self)
        return party.count
    }
    
    public func searchParty() -> Results<Party> {
        let realm = try! Realm()
        let party = realm.objects(Party.self)
        return party
    }
    
}
