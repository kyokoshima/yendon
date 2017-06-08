//
//  Utils.swift
//  YenDon
//
//  Created by 横島健一 on 2017/06/08.
//  Copyright © 2017年 info.tmpla. All rights reserved.
//

import UIKit

class Utils {
    static func length(value: NSDecimalNumber) -> Int {
        return length(value: value.description)
    }
    
    static func length(value: Int) -> Int {
        return length(value: value.description)
    }
    
    private static func length(value: String) -> Int {
        return value.characters.count
    }
    
    static func wellNumber(value:NSDecimalNumber) -> Int {
        let length = self.length(value: value) - 1
        let tmp = String().padding(toLength: length, withPad: "9", startingAt: 0)
        return Int(tmp)! + 1
    }
}
