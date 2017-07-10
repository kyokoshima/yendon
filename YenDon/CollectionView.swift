//
//  CollectionViewCollectionReusableView.swift
//  YenDon
//
//  Created by 横島健一 on 2017/07/10.
//  Copyright © 2017年 info.tmpla. All rights reserved.
//

import UIKit

class CollectionView: UICollectionView {
    @IBInspectable var type: String? = ""
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
//        fatalError("init(coder:) has not been implemented")
    }
    
    func isOversea() -> Bool {
        return type == "oversea"
    }
    
    func isLocal() -> Bool {
        return type == "local"
    }
    
    
}
