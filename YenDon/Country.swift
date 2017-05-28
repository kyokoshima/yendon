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
    
    dynamic private var id = 0
    dynamic var name = "";
    dynamic private var _image: UIImage? = nil
    dynamic private var imageData: NSData? = nil
    dynamic var image: UIImage? {
        set{
            self._image = newValue
            if let value = newValue {
                self.imageData = UIImagePNGRepresentation(value) as NSData?
            }
        }
        get {
            if let image = self._image {
                return image
            }
            if let data = self.imageData {
                self._image = UIImage(data: data as Data)
                return self._image
            }
            return nil
        }
    
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    static func loadAll() -> [Country] {
        let countries = realm.objects(Country.self).sorted(byKeyPath: "id", ascending: false)
        var ret: [Country] = []
        for country in countries {
            ret.append(country)
        }
        return ret
    }
    
    static func create(id: Int, name: String, image:UIImage) -> Country {
        let country = Country()
        country.id = id
        country.image = image
        country.name = name
        return country
    }
    
    static func find(id:Int) -> Country? {
        if let country = realm.object(ofType: Country.self, forPrimaryKey: id) {
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
            Country.realm.add(self)
        }
    }
    
// Specify properties to ignore (Realm won't persist these)
    
  override static func ignoredProperties() -> [String] {
    return ["image", "_image"]
  }
}
