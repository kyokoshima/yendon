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
    
    static func wellNumber(length: Int) -> NSDecimalNumber {
        var tmp:String = "1" + String(repeating: "0", count: length)
        tmp = tmp.substring(to: tmp.index(tmp.startIndex, offsetBy: length))
        return NSDecimalNumber(value: Int(tmp)!)
    }
    static func wellNumber(value:NSDecimalNumber) -> NSDecimalNumber {
        let length = self.length(value: value) - 1
        return wellNumber(length: length)
    }
    
    static func calcAmount(currentValue: NSDecimalNumber, moveLength:Double) -> NSDecimalNumber {
        let plus = moveLength <= 0 // 上がマイナス、下が＋なので逆転
        
        if currentValue.compare(NSDecimalNumber.zero) == ComparisonResult.orderedSame && !plus {
            return NSDecimalNumber.zero
        }
        
        
        var addValue:NSDecimalNumber = NSDecimalNumber(value:calcAddValue(source: Int(moveLength)))
        
        
        var sourceValue = currentValue
        
        
        
        
        let handler = NSDecimalNumberHandler(roundingMode: .plain, scale: 2, raiseOnExactness: false, raiseOnOverflow: false, raiseOnUnderflow: false, raiseOnDivideByZero: false)
        
        // 値増減した後の値を検証
        let willValue = currentValue.adding(addValue)
        let compared = willValue.compare(NSDecimalNumber.zero)
        if compared == ComparisonResult.orderedAscending || compared == ComparisonResult.orderedSame {
            return NSDecimalNumber.zero
        }
        let wellValue = Utils.wellNumber(value: willValue)
        let currentLength = Utils.length(value: currentValue)
        let willLength = Utils.length(value: willValue)
        if currentLength == 1 {
            // 0の場合
            sourceValue = wellValue
            addValue = Utils.wellNumber(length: 2)
            print("c == 0 will\(willValue) current:\(currentValue) add\(addValue)")
            
        } else if currentLength > willLength {
            sourceValue = wellValue
            print("c > w will\(willValue) current:\(currentValue) add\(addValue)")
            
            addValue = Utils.wellNumber(length: willLength)
        } else if currentLength < willLength {
            sourceValue = wellValue
            addValue = Utils.wellNumber(length: willLength)
            print("c < w will\(willValue) current:\(currentValue) add\(addValue)")
            
        } else {
            // addValueの値を今の桁数にする
            let addLength = Utils.length(value: addValue)
            addValue = Utils.wellNumber(length: addLength)
            print("will\(willValue) current:\(currentValue) add\(addValue)")
            
        }
        //        if !plus {
        //            addValue = addValue.multiplying(by: NSDecimalNumber(value: -1))
        //        }
        //
        print("will\(willValue) current:\(currentValue) add\(addValue)")
        
        let value = sourceValue.adding(addValue, withBehavior: handler)
        
        return value
        
    }
}
