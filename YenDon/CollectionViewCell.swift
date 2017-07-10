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

    
    func setRate(_ rate: Double) {
        let digit = 100000.0
        let rateString = (round(rate * digit) / digit).description
        let symbol = country!.symbol
        labelRate.text = "\(symbol)1 = \(rateString)"
    }
    
    func setAmount(_ amount:Double, pair: Country) {
//        let rate = country?.rates.filter("name = %@", pair.name).sorted(by: "updated").first
    
    }
}
