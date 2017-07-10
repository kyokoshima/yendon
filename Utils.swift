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
//        let length = self.length(value: value) - 1
//        return wellNumber(length: length)
        let stringValue = value.stringValue
        let firstDigit = stringValue.substring(to: stringValue.index(after: stringValue.startIndex))
        let willLength = length(value: value) - 1
        let willString = "\(firstDigit)" + String(repeating: "0", count: willLength)
        return NSDecimalNumber(string: willString)
    }
    
    static func calcAmount(_ currentValue: Double, moved: Int, min: Double) -> Double {
        let amount = currentValue + Double(moved)
        if (amount <= min) {
            return min
        }
        return amount
    }
    
    static func calcAmount(_ currentValue: NSDecimalNumber, moveLength:Double) -> NSDecimalNumber {
//        let plus = moveLength <= 0 // 上がマイナス、下が＋なので逆転
        if (currentValue == NSDecimalNumber.zero && moveLength > 0) {
            return NSDecimalNumber.zero
        }
        print(Int(moveLength))
        
        if currentValue.compare(NSDecimalNumber.zero) == .orderedAscending {
            return NSDecimalNumber.zero
        }
    
        let addValue = calcAddValue(source: Int(moveLength), currentValue: currentValue)
        let willValue = currentValue.adding(addValue)
        var calclatedValue:NSDecimalNumber = currentValue
        if length(value: willValue) != length(value: currentValue) {
            calclatedValue = wellNumber(value: willValue)
        } else {
            calclatedValue = currentValue
        }
        
        let value = calclatedValue.adding(addValue)

        
        return value
        
    }
    
    private static func calcAddValue(source: Int, currentValue: NSDecimalNumber) -> NSDecimalNumber {
        print(abs(source) / 10)
        if abs(source) / 10 < 1 { return NSDecimalNumber.zero }
        let plus = source < 0 // マイナスならプラス、プラスならマイナス
        let currentLength = length(value: currentValue)
        var result: NSDecimalNumber?
        if plus {
            result = wellNumber(length: currentLength)
        } else {
            result = wellNumber(length: currentLength).multiplying(by: NSDecimalNumber(value: -1))
        }
        return result!
    }
    
    private static func calcAddValue(source:Int) -> Int {
        //        var result = source;
        
        let source = source == 0 ? 1 : source
        var length = abs(source / 50)
        if length == 0 {
            length = 1
        }
        let base = 10
        var result = NSDecimalNumber(decimal: pow(Decimal(base), length)).intValue
        if abs(result) > 100000  {
            result = 100000
        }
        return result
        
    }
}
