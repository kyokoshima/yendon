//
//  CollectionView.swift
//  YenDon
//
//  Created by 横島健一 on 2017/05/13.
//  Copyright © 2017年 info.tmpla. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var labelRate: UILabel!
    @IBOutlet weak var ind: UIActivityIndicatorView!
    @IBOutlet weak var textAmount: UITextField!
    @IBOutlet weak var image: UIImageView!
    var country:Country?
    var pairCountry: Country?
    dynamic var amount = 0.0
    func setRate(_ rate: Double) {
        let digit = 100000.0
        let rateString = (round(rate * digit) / digit).description
        let symbol = country!.symbol
        labelRate.text = "\(symbol)1 = \(rateString)"
    }
    
    func putAmount(_ amount: Double) {
        self.amount = amount
        self.textAmount.text = toSuitableAmountForDigit(amount).description

    }
    
    func setAmount(_ amount:Double, pair: Country) {
//        let rate = country?.rates.filter("pairCurrency = %@", pair.name).sorted(byKeyPath: "updated", ascending: false).first
//        print("amount: \(amount), pair: \(rate?.amount)")
//        let localAmount = amount * (rate?.amount)!
//        self.textAmount.text = localAmount.description
        self.amount = amount
        self.textAmount.text = toSuitableAmountForDigit(amount).description
    }
    
    
    func setAmountText(_ amount:Double) {
        if pairCountry != nil {
//            let rate = country?.rates.filter("pairCurrency = %@", pairCountry?.name).sorted(byKeyPath: "updated", ascending: true).first
//            let numberOfPlaces = country?.minimumDigit
            let rate = country?.pairCurrencyRate(pairCountry!)
            let realAmount = round(amount * rate!)
//            if numberOfPlaces == 0 {
//                self.textAmount.text = toSuitableAmountForDigit(realAmount).description
//                
//            } else {
//                let multiplier = pow(10.0, numberOfPlaces!)
//                self.textAmount.text = toSuitableAmountForDigit(((realAmount * multiplier) / multiplier)).description
//            }
            self.textAmount.text = toSuitableAmountForDigit(realAmount).description
        } else {
            let minAmount = country?.minimumAmount
            self.textAmount.text = toSuitableAmountForDigit(minAmount!).description
        }
    }
    

    private func toSuitableAmountForDigit(_ amount:Double) -> NSNumber {
        let numberOfPlaces = country?.minimumDigit
        if (numberOfPlaces == 0) {
            return NSNumber(value: Int(amount))
        } else {
            let multiplier = pow(10.0, numberOfPlaces!)
            return NSNumber(value: (amount * multiplier) / multiplier)
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
//        print(keyPath)
//        print(object)
        let amount = change?[.newKey] as! Double
        self.setAmountText(amount)
        
    }
    
    
    
}
