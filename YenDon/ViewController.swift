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
        [Country.find(Const.JPY)!,
        Country.find(Const.USD)!,
        Country.find(Const.AUD)!]
    var localCountries:[Country] = [Country.find(Const.VND)!]
    var localPanReconizer: UIPanGestureRecognizer!
    var overseaPanReconizer: UIPanGestureRecognizer!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        overseasCollectionView.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
        localCollectionView.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
        localPanReconizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan(reconizer:)))
        overseaPanReconizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan(reconizer:)))
        overseaPanReconizer.cancelsTouchesInView = false
        
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
        var rateText: String?
        if collectionView == overseasCollectionView {
            countries = overseaCountries
            panReconizer = overseaPanReconizer
            
            
        } else {
            countries = localCountries
            panReconizer = localPanReconizer
        }
        let country = countries?[indexPath.row]
        
        cell.image.image = country?.image
        cell.labelRate.text = country?.rates.first?.amount.description
        cell.tag = indexPath.row
        cell.contentView.isUserInteractionEnabled = false
        cell.textAmount.addGestureRecognizer(panReconizer!)
        cell.textAmount.delegate = self
        if (cell.textAmount.text?.isEmpty)! {
            cell.textAmount.text = "0"
        }
//        print("セル表示中〜　\(cell)")
        if lastSelectedCell == nil {
            lastSelectedCell = cell
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let api = Api()
        let c:CollectionViewCell = cell as! CollectionViewCell
//        c.ind.startAnimating()
        print("willセル\(cell.tag)")
    }
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        print("didセル\(cell.tag) last\(lastSelectedCell?.tag)")
        swapReconizer(cell: cell as! CollectionViewCell)

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
       
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
    }
    //
    var lastPointY = 0.0
    func handlePan( reconizer: UIPanGestureRecognizer) {
        if (reconizer.state == .changed) {
            if let tf:UITextField = reconizer.view as? UITextField {
                let point = reconizer.translation(in: self.view)
                print(point.y)
                let pointY = Int(point.y) * -1
                let amount = Double(tf.text!)
                let toBeAmount = Utils.calcAmount(amount!, moved: pointY).description
                syncAmount(amount: toBeAmount)
            }
        }
//        let velocity = reconizer.velocity(in: self.view)
//        print(velocity)
//        let distance = lastPointY - Double(point.y)
//        print(distance)
//        let pointY = Double(point.y)
//        print("last:\(lastPointY) current:\(pointY) abs:\(abs(lastPointY - pointY))")
////        if (abs(pointY - lastPointY) > 10) {
//            if let tf:UITextField = reconizer.view as? UITextField {
//                let amount = Utils.calcAmount(NSDecimalNumber(string: tf.text), moveLength: distance).description
//                syncAmount(amount: amount)
//                            lastPointY = pointY
//            }
//
////        }

    }
    
    private func syncAmount(amount: String) {
        let tf1:UITextField = (overseasCollectionView.visibleCells[0] as! CollectionViewCell).textAmount
        let tf2:UITextField = (localCollectionView.visibleCells[0] as! CollectionViewCell).textAmount
        tf1.text = amount
        tf2.text = amount
        
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return false
    }
    
    
    

    
    private func swapReconizer(cell: CollectionViewCell) {
        if cell.superview != lastSelectedCell?.superview {
            return
        }
        
        let v:UICollectionView = cell.superview as! UICollectionView
        let c:CollectionViewCell = v.visibleCells[0] as! CollectionViewCell
        
        // if selected same as before, nothing to do
//        print("\(c.tag), \(lastSelectedCell?.tag)")
        if c == lastSelectedCell {
            return
        }
        
        var panReconizer:UIPanGestureRecognizer?
        if v == overseasCollectionView {
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
}

extension ViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        print(string)
        return false
    }
}


