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
    
    func setAmount(_ amount:Double, pair: Country) {
        let rate = country?.rates.filter("pairCurrency = %@", pair.name).sorted(byKeyPath: "updated", ascending: false).first
//        print("amount: \(amount), pair: \(rate?.amount)")
//        let localAmount = amount * (rate?.amount)!
//        self.textAmount.text = localAmount.description
        self.amount = amount
        self.textAmount.text = amount.description
    }
    
    func setAmountText(_ amount:Double) {
        let rate = country?.rates.filter("pairCurrency = %@", pairCountry?.name).sorted(byKeyPath: "updated", ascending: true).first
        self.textAmount.text = (amount * rate!.amount).description
    }
    

    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
//        print(keyPath)
//        print(object)
        let amount = change?[.newKey] as! Double
        self.setAmountText(amount)
        
    }
    
    
    
}
