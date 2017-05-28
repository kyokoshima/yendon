//
//  ViewController.swift
//  YenDon
//
//  Created by 横島健一 on 2017/05/13.
//  Copyright © 2017年 info.tmpla. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    @IBOutlet weak var localCollectionView: UICollectionView!

    @IBOutlet weak var overseasCollectionView: UICollectionView!
    var overseaCountries:[Country] =
        [Country.create(id:0, name:"JPY", image: #imageLiteral(resourceName: "Japan")),
        Country.create(id: 1, name: "USD", image: #imageLiteral(resourceName: "United-States")),
        Country.create(id: 2, name: "AUD", image: #imageLiteral(resourceName: "Australia"))]
    var localCountries:[Country] = [Country.create(id:0, name:"VND", image: #imageLiteral(resourceName: "Vietnam"))]
    var localPanReconizer: UIPanGestureRecognizer!
    var overseaPanReconizer: UIPanGestureRecognizer!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        overseasCollectionView.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
        localCollectionView.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
        localPanReconizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan(reconizer:)))
        overseaPanReconizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan(reconizer:)))

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == overseasCollectionView {
            return overseaCountries.count
        } else {
            return localCountries.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:CollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionViewCell
        var countries:[Country]?
        var panReconizer:UIPanGestureRecognizer?
        if collectionView == overseasCollectionView {
            countries = overseaCountries
            panReconizer = overseaPanReconizer
        } else {
            countries = localCountries
            panReconizer = localPanReconizer
        }
        let image:UIImageView = cell.image
        image.image = countries?[indexPath.row].image
        cell.tag = indexPath.row
        cell.contentView.isUserInteractionEnabled = false
        cell.textAmount.addGestureRecognizer(panReconizer!)
        cell.textAmount.delegate = self
        return cell
    }
    
    // FlowLayoutの
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellSize: CGFloat = self.view.frame.size.width
        return CGSize(width: cellSize, height: collectionView.frame.size.height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0,0,0,0)
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        let v:UICollectionView = scrollView as! UICollectionView
        let c:CollectionViewCell = v.visibleCells[0] as! CollectionViewCell
    
        print("begin decelerating", c.tag)
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        let v:UICollectionView = scrollView as! UICollectionView
        let c:CollectionViewCell = v.visibleCells[0] as! CollectionViewCell
        print("begin dragging", c.tag)
    }
    
//    var lastSelectedCellIndex:Int = 0
    var lastSelectedCell:CollectionViewCell?
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView != lastSelectedCell?.superview {
            return
        }
        let v:UICollectionView = scrollView as! UICollectionView
        let c:CollectionViewCell = v.visibleCells[0] as! CollectionViewCell
        var panReconizer:UIPanGestureRecognizer?
        if scrollView == overseasCollectionView {
            panReconizer = self.overseaPanReconizer
        } else {
            panReconizer = localPanReconizer
        }
        
    
        print("end decelerating", c.tag)
        if lastSelectedCell != c {
            c.textAmount.delegate = self
            c.textAmount.addGestureRecognizer(panReconizer!)
            lastSelectedCell?.textAmount.removeGestureRecognizer(panReconizer!)
        }
        lastSelectedCell = c
    }
    
    //
    func handlePan( reconizer: UIPanGestureRecognizer) {
        let point = reconizer.translation(in: self.view)
        print(point)
        if let tf:UITextField = reconizer.view as? UITextField {
            tf.text = point.y.description
        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return false
    }
}

extension ViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        print(string)
        return false
    }
}


