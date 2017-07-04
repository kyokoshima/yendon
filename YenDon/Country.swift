//
//  Country.swift
//  YenDon
//
//  Created by 横島健一 on 2017/05/21.
//  Copyright © 2017年 info.tmpla. All rights reserved.
//

import UIKit
import RealmSwift
import SwiftDate

class Country: Object {
    static let realm = try! Realm()
    
    dynamic var name = "";
    dynamic private var _image: UIImage? = nil
    dynamic private var imageData: Data? = nil
    let rates = List<Rate>()
    dynamic var image: UIImage? {
        set{
            self._image = newValue
            if let value = newValue {
                self.imageData = UIImagePNGRepresentation(value) as Data?
            }
        }
        get {
            if let image = self._image {
                return image
            }
            if let data = self.imageData {
                self._image = UIImage(data: data)
                return self._image
            }
            return nil
        }
    
    }
    
    override static func primaryKey() -> String? {
        return "name"
    }
    
    static func updateFromApi(_ finished: @escaping () -> Void) {
        let countries = loadAll()
        // レートの最新レコードが今日より新しければ作成
        let latestRateDate = Rate.latestDate()
        if Date().isAfter(date: latestRateDate, granularity: .day) {
            // 古ければ更新
            Api().request(["JPYVND", "USDVND","AUDVND"], success: { (data) in
                //
                for (key, rate) in data {
//                    print (rate)
                    let id = rate["id"].stringValue.components(separatedBy: "VND")[0]
                    let bid = rate["Bid"].doubleValue
                    let ask = rate["Ask"].doubleValue
                    let updated = rate["Date"].stringValue.date(format: DateFormat.custom("MM/SS/yyyy"))?.absoluteDate
                    try! realm.safeWrite {
                        Country.find(id)?.rates.append(Rate.create(Const.VND, bid: bid, ask: ask, updated: updated!))
                        // 基軸側
                        Country.find(Const.VND)?.rates.append(Rate.create(id, bid: 1 / bid, ask : 1 / ask, updated: updated!))
                    }
                }
                finished()
            }, fail: { (error) in
                //
                createInitialRates()
                finished()
            })
        } else {
            finished()
        }

        
    }
    
    static func loadAll() -> [Country] {
        let countries = realm.objects(Country.self).sorted(byKeyPath: "name", ascending: true)
        var ret: [Country] = []
        for country in countries {
            ret.append(country)
        }
        return ret
    }
    
    static func create(_ name: String, image:UIImage) -> Country {
        let country = Country()
        country.image = image
        country.name = name
        return country
    }
    
    static func find(_ name:String) -> Country? {
        if let country = realm.object(ofType: Country.self, forPrimaryKey: name) {
            return country
        }
        return nil
    }
    
    static func createInitialCountries() {
        print("initial data creating")
        // なければ作成
        
        let vnd = create(Const.VND, image: #imageLiteral(resourceName: "Vietnam"))
        let jpy = create(Const.JPY, image: #imageLiteral(resourceName: "Japan"))
        let usd = create(Const.USD, image: #imageLiteral(resourceName: "United-States"))
        let aud = create(Const.AUD, image: #imageLiteral(resourceName: "Australia"))
        

        vnd.save()
        jpy.save()
        usd.save()
        aud.save()
        
    }
    
    static func createInitialRates() {
        var dc = DateComponents()
        dc.year = 2017
        dc.month = 7
        dc.day = 1
        let initialDate = DateInRegion(components: dc)!.absoluteDate

        // 為替初期値
        let vnd = Country.find(Const.VND)!
        vnd.rates.append(Rate.create(Const.JPY, bid: Const.RATE_VND_JPY, updated: initialDate))
        vnd.rates.append(Rate.create(Const.USD, bid: Const.RATE_VND_USD, updated: initialDate))
        vnd.rates.append(Rate.create(Const.AUD, bid: Const.RATE_VND_AUD, updated: initialDate))
        vnd.save()
        
        let jpy = Country.find(Const.JPY)!
        jpy.rates.append(Rate.create(Const.JPY, bid: 1 / Const.RATE_VND_JPY, updated: initialDate))
        jpy.save()
        let usd = Country.find(Const.USD)!
        usd.rates.append(Rate.create(Const.USD, bid: 1 / Const.RATE_VND_USD, updated: initialDate))
        usd.save()
        
        let aud = Country.find(Const.AUD)!
        aud.rates.append(Rate.create(Const.USD, bid: 1 / Const.RATE_VND_AUD, updated: initialDate))
        aud.save()

    }
    
//    static func lastId() -> Int {
//        if let country = realm.objects(Country).last {
//            return country.id + 1
//        } else {
//            return 1
//        }
//    }
    
    func save() {
        try! Country.realm.safeWrite {
            Country.realm.add(self, update: true)
        }
    }
    
// Specify properties to ignore (Realm won't persist these)
    
  override static func ignoredProperties() -> [String] {
    return ["image", "_image"]
  }
}
