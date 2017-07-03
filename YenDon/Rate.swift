//
//  Rate.swift
//  YenDon
//
//  Created by 横島健一 on 2017/07/01.
//  Copyright © 2017年 info.tmpla. All rights reserved.
//

import Foundation
import RealmSwift

class Rate: Object {
    static let realm = try! Realm()
    
    dynamic private var id = NSUUID().uuidString
    dynamic var pairCurrency = ""
    dynamic var updated = Date()
    dynamic var bid = 0.0
    dynamic var ask = 0.0
    dynamic var amount: Double{
        get{
            return bid
        }
    }
    let countries = LinkingObjects(fromType: Country.self, property: "rates")
    
    static func create(_ pairCurrency: String, bid: Double, ask: Double, updated: Date) -> Rate {
        let rate = Rate()
        rate.pairCurrency = pairCurrency
        rate.bid = bid
        rate.ask = ask
        return rate
    }

    static func create(_ pairCurrency: String, bid: Double) -> Rate {
        return create(pairCurrency, bid: bid, ask: bid, updated: Date())
    }
    
    static func create(_ pairCurrency: String, bid: Double, updated: Date) -> Rate {
        return create(pairCurrency, bid: bid, ask: bid, updated: updated)
    }

    
    func save() {
        try! Rate.realm.write {
            if let pair = Country.find(self.pairCurrency) {
//                pair.rates.append(Rate.create(pair.name, bid: self.amountFromPair()))
//                pair.save()
                Rate.realm.add(self, update: true)
            }
            
        }
    }
    
    static func latestDate() -> Date {
        let latest =  realm.objects(self).sorted(byKeyPath: "updated", ascending: false).first
        return (latest?.updated ?? Date().prevMonth)
    }
    
    func amountFromPair() -> Double {
        return 1 / self.bid
    }
    
// Specify properties to ignore (Realm won't persist these)
    
//  override static func ignoredProperties() -> [String] {
//    return []
//  }
}
