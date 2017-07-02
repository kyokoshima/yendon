//
//  Country.swift
//  YenDon
//
//  Created by 横島健一 on 2017/05/21.
//  Copyright © 2017年 info.tmpla. All rights reserved.
//

import UIKit
import RealmSwift

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
    
//    static func lastId() -> Int {
//        if let country = realm.objects(Country).last {
//            return country.id + 1
//        } else {
//            return 1
//        }
//    }
    
    func save() {
        try! Country.realm.write {
            Country.realm.add(self, update: true)
        }
    }
    
// Specify properties to ignore (Realm won't persist these)
    
  override static func ignoredProperties() -> [String] {
    return ["image", "_image"]
  }
}
