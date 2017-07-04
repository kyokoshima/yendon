//
//  CollectionViewDelegate.swift
//  YenDon
//
//  Created by 横島健一 on 2017/07/04.
//  Copyright © 2017年 info.tmpla. All rights reserved.
//

import UIKit

class CollectionViewDelegate: NSObject, UICollectionViewDelegate {
    var numberOfItemsInSection:((Int) -> ())?
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //
        return 0
    }
    
    init(numberOfItemsInSection: ((Int) -> ())? = nil) {
        self.numberOfItemsInSection = numberOfItemsInSection
    }
    
    
}
