//
//  Constant.swift
//  YenDon
//
//  Created by 横島健一 on 2017/07/01.
//  Copyright © 2017年 info.tmpla. All rights reserved.
//
import UIKit
struct Const {
    static let VND = "VND"
    static let JPY = "JPY"
    static let USD = "USD"
    static let AUD = "AUD"
    static let countries = [VND, JPY, USD, AUD]
    static let IMAGE_VND = #imageLiteral(resourceName: "Vietnam")
    static let IMAGE_JPY = #imageLiteral(resourceName: "Japan")
    static let IMAGE_USD = #imageLiteral(resourceName: "United-States")
    static let IMAGE_AUD = #imageLiteral(resourceName: "Australia")
    static let RATE_VND_JPY = 0.004944
    static let RATE_VND_USD = 0.0000439
    static let RATE_VND_AUD = 0.0000572235
    static let SYMBOLS = [Const.VND: "₫", Const.JPY: "￥", Const.USD: "US＄", Const.AUD: "AU$"]
    static let COUNTRIES = [
        Country.create(VND, image: #imageLiteral(resourceName: "Vietnam"), symbol: "₫", minAmount: 100, minDigit: 0.0),
        Country.create(JPY, image: #imageLiteral(resourceName: "Japan"), symbol: "¥", minAmount: 1, minDigit: 0.0),
        Country.create(USD, image: #imageLiteral(resourceName: "United-States"), symbol: "US$", minAmount: 1, minDigit: 2.0),
        Country.create(AUD, image: #imageLiteral(resourceName: "Australia"), symbol: "AU$", minAmount: 1, minDigit: 2.0),
        
    ]
}
