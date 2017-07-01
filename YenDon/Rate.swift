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
    dynamic var updated = NSDate()
    dynamic var amount = 0.0
    let countries = LinkingObjects(fromType: Country.self, property: "rates")
    
    static func create(_ pairCurrency: String, amount: Double) -> Rate {
        let rate = Rate()
        rate.pairCurrency = pairCurrency
        rate.amount = amount
        return rate
    }
    
    func save() {
        try! Rate.realm.write {
            Rate.realm.add(self, update: true)
        }
    }
    
    func amountFromPair() -> Double {
        return 1 / self.amount
    }
    
// Specify properties to ignore (Realm won't persist these)
    
//  override static func ignoredProperties() -> [String] {
//    return []
//  }
}
