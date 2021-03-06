//
//  ViewController.swift
//  YenDon
//
//  Created by 横島健一 on 2017/05/13.
//  Copyright © 2017年 info.tmpla. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    @IBOutlet weak var localCollectionView: CollectionView!
    @IBOutlet weak var overseasCollectionView: CollectionView!

    var overseaCountries:[Country] = Country.loadOverseas(excludeCountry: Const.VND)
    var localCountries:[Country] = Country.loadLocals()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        overseasCollectionView.countries = overseaCountries
        localCollectionView.countries = localCountries
        overseasCollectionView.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
        localCollectionView.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(_ animated: Bool) {
        if self.isReadyToShow() {
            let localCell = localCollectionView.currentCell()
            let overseasCell = overseasCollectionView.currentCell()
            localCell.country = localCountries.first
            localCell.pairCountry = overseaCountries.first
            overseasCell.country = overseaCountries.first
            overseasCell.pairCountry = localCountries.first
//            setObserver(localCollectionView)
//            setObserver(overseasCollectionView)
            setObserver(localCell, pairCell: overseasCell)
        }
    }

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == overseasCollectionView {
            return overseaCountries.count
        } else {
            return localCountries.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("start displaying")
        let cell:CollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionViewCell
//        var countries:[Country]!
//        var pairCountries: [Country]!
        let cv:CollectionView = collectionView as! CollectionView

//        let oppositeView:CollectionView = self.oppositeView(cv)
//        let pairCountries = self.pairCountries(cv)
//        let countries = self.currentCountries(cv)

        let country = cv.countries[indexPath.row]
//        var pairCountry:Country?
//        if ((oppositeView.visibleCells.count) > 0) {
//            let oppositeIndexPath = oppositeView.indexPath(for: (oppositeView.visibleCells[0]))
//            if (oppositeIndexPath?.count)! > 0 {
//                pairCountry = oppositeView.countries[(oppositeIndexPath?.row)!]
////                print("opposite \(pairCountry)")
//                // 最初だけ付ける
////                self.setObserver(cv)
////                self.setObserver(oppositeView)
//            }
//        }
//        print("#################### \(pairCountry)")
        cell.image.image = country.image
        cell.country = country
//        cell.pairCountry = pairCountry

        
        cell.setRate((country.rates.first?.amountFromPair())!)
        cell.tag = indexPath.row
        cell.contentView.isUserInteractionEnabled = false
        cell.textAmount.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePan(reconizer:))))
        cell.textAmount.delegate = self
        if (cell.textAmount.text?.isEmpty)! {
//            cell.textAmount.text = country.minimumAmount.description
            cell.setAmountText(1)
            
        }
        return cell
    }
    
    private func pairCountry(_ collectionView: CollectionView) -> Country {
        let pairCountries = self.pairCountries(collectionView)
        let oppositeView = self.oppositeView(collectionView)
        var pairCountry:Country?
        if ((oppositeView.visibleCells.count) > 0) {
            let oppositeIndexPath = oppositeView.indexPath(for: (oppositeView.visibleCells[0]))
            if (oppositeIndexPath?.count)! > 0 {
                pairCountry = pairCountries[(oppositeIndexPath?.row)!]
//                print("opposite \(pairCountry)")
            }
        }
        return pairCountry!
    }
    
    private func currentCountries(_ collectionView: CollectionView) -> [Country] {
        return collectionView.isLocal() ? localCountries : overseaCountries
    }
    
    private func pairCountries(_ collectionView: CollectionView) -> [Country] {
        return collectionView.isLocal() ? overseaCountries : localCountries
    }
    
    private func oppositeView(_ collectionView: CollectionView) -> CollectionView {
        return collectionView.isLocal() ? overseasCollectionView : localCollectionView
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let c:CollectionViewCell = cell as! CollectionViewCell
//        c.ind.startAnimating()
        print("willセル\(String(describing: c.country?.name))")
        if self.isReadyToShow() {
//            setObserver(collectionView as! CollectionView)
//            setObserver(oppositeView(collectionView as! CollectionView))
            let currentCell = c
            let pairCell = (oppositeView(collectionView as! CollectionView)).currentCell()
            setObserver(currentCell, pairCell: pairCell)
        }

    }
    
    func isReadyToShow() -> Bool {
        return localCollectionView.visibleCells.count > 0 && overseasCollectionView.visibleCells.count > 0
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        print("viewDidScroll")
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let c:CollectionViewCell = cell as! CollectionViewCell
        print("didセル\(c.country?.name) last\(lastSelectedCell?.tag)")
        if lastSelectedCell != cell {
//            swapReconizer(cell: cell as! CollectionViewCell)
        }
//        let currentCell = completelyVisibleCell(collectionView)
//        print("perfect !: \(currentCell)")
//        let oppositeCell = completelyVisibleCell(oppositeView(collectionView as! CollectionView))
//        currentCell.addObserver(oppositeCell, forKeyPath: "amount", options: [.new, .old], context: nil)
//        oppositeCell.addObserver(currentCell, forKeyPath: "amount", options: [.new, .old], context: nil)
//        setObserver(collectionView as! CollectionView)
        
    }
    
    // cellを引数にしないとダメ
    
    private func setObserver(_ cell:CollectionViewCell, pairCell:CollectionViewCell) {
        cell.addObserver(pairCell, forKeyPath: "amount", options: [.new, .old], context: nil)
        pairCell.addObserver(cell, forKeyPath: "amount", options: [.new, .old], context: nil)
//        [localCollectionView, overseasCollectionView].forEach { (cv) in
//            if let currentCell:CollectionViewCell = cv?.currentCell() {
//                print("perfect !: \(currentCell)")
//                let oppositeCell = oppositeView(cv!).currentCell()
//                currentCell.addObserver(oppositeCell, forKeyPath: "amount", options: [.new, .old], context: nil)
//                oppositeCell.addObserver(currentCell, forKeyPath: "amount", options: [.new, .old], context: nil)
//            } else {
//                print("couldn't set observer")
//            }
//
//        }
    }
    
//    private func removeObserver(_ collectionView:CollectionView) {
//        collectionView.currentCell().removeObserver(nil, forKeyPath: "amount", context: nil)
//    }
    
//    private func completelyVisibleCell(_ collectionView: UICollectionView) -> CollectionViewCell {
//        return collectionView.visibleCells.filter {
//            collectionView.bounds.contains($0.frame)
//        }.first as! CollectionViewCell
//    }
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
        lastSelectedCell = c
        
    }
    
//    var lastSelectedCellIndex:Int = 0
    var lastSelectedCell:CollectionViewCell?
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
//        let c:CollectionViewCell = completelyVisibleCell(scrollView as! CollectionView)
//       print("end decelerating\(c.country?.name)")
//        setObserver(scrollView as! CollectionView)
//        setObserver(oppositeView(scrollView as! CollectionView))
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
    }
    //
    var lastPointY = 0.0
    func handlePan( reconizer: UIPanGestureRecognizer) {
        if (reconizer.state == .changed) {
            if let tf:UITextField = reconizer.view as? UITextField {
                let point = reconizer.translation(in: self.view)
                //                print(point.y)
                let pointY = Int(point.y) * -1
                let amountText = tf.text
                let formatter = NumberFormatter()
                let cell:CollectionViewCell = reconizer.view?.superview as! CollectionViewCell
                let country = cell.country
                
                formatter.numberStyle = .currency
                formatter.currencySymbol = country?.symbol
                let number = formatter.number(from: amountText!)
                var amount:Double?
                if number  == nil {
                    amount = Double(amountText!)!
                } else {
                    amount = Double(number!)
                }
                let pairCountry = self.pairCountry(cell.superview as! CollectionView)
                let toBeAmount = Utils.calcAmount(amount!, moved: pointY, min: (country?.minimumAmount)!)
                cell.putAmount(toBeAmount)
                
            }
        }
        
        
    }
    
    private func syncAmount(amount: String, pairRate: Double) {
        let tf1:UITextField = (overseasCollectionView.visibleCells[0] as! CollectionViewCell).textAmount
        let tf2:UITextField = (localCollectionView.visibleCells[0] as! CollectionViewCell).textAmount
        tf1.text = amount
        tf2.text = amount
        
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


