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
                    print (rate)
                }
            }, fail: { (error) in
                //
                createInitialRates()
            })
        }
//        for country in countries {
//            let latestRate = country.rates.sorted(byKeyPath: "updated", ascending: false).first
//            print(latestRate)
//            if (latestRate?.updated) != nil {
//                let today = Date()
//                let after = today.isAfter(date: (latestRate?.updated)!, granularity: .day)
//                // 更新日が古ければ更新
//                if after {
//                    Api().request(["JPYVND", "USDVND","AUDVND"], success: { (data) in
//                        //
//                        let vnd = Country.find("VND")
//                        for (key, rate) in data {
//                            print(rate)
//                            let id = rate["id"].stringValue.components(separatedBy: "VND")[0]
//                            let amount = rate["Bid"].doubleValue
//                            
//                            let rec = vnd?.rates.filter("pairCurrency = %@", id).first
//                            print("rec: \(rec)")
////                            let newRate = vnd?.rates.append(Rate.create(id, ))
//                        }
//                        
//                        finished()
//                    }, fail: { (error) in
//                        //
//                        print(error)
//                        // エラーのときだけ初期データ
//                        createInitialRates()
//                        finished()
//                    })
//                    
//                } else {
//                    finished()
//                }
//                
//            }
//        }
        
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
        
//        // 日付デフォルト
//        var dc = DateComponents()
//        dc.year = 2017
//        dc.month = 7
//        dc.day = 1
//        let initialDate = DateInRegion(components: dc)!.absoluteDate
//        print(initialDate)
//        // 為替初期値
//        vnd.rates.append(Rate.create("JPY", bid: Const.RATE_VND_JPY, updated: initialDate))
//        vnd.rates.append(Rate.create("USD", bid: Const.RATE_VND_USD, updated: initialDate))
//        vnd.rates.append(Rate.create("AUD", bid: Const.RATE_VND_AUD, updated: initialDate))
        vnd.save()
//
//        jpy.rates.append(Rate.create(Const.JPY, bid: 1 / Const.RATE_VND_JPY, updated: initialDate))
        jpy.save()
//        usd.rates.append(Rate.create(Const.USD, bid: 1 / Const.RATE_VND_USD, updated: initialDate))
        usd.save()
//
//        aud.rates.append(Rate.create(Const.USD, bid: 1 / Const.RATE_VND_AUD, updated: initialDate))
        aud.save()
//
//        try! realm.commitWrite()
        

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
