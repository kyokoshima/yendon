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
    var cellForItemAt:((IndexPath) -> (UICollectionViewCell))?
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellFormItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
    
    init(
        numberOfItemsInSection: ((Int) -> ())? = nil,
        cellForItemAt: ((IndexPath) -> (UICollectionViewCell))? = nil)
    {
        self.numberOfItemsInSection = numberOfItemsInSection
        self.cellForItemAt = cellForItemAt
    }
    
    
}
