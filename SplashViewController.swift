//
//  SplashViewController.swift
//  YenDon
//
//  Created by 横島健一 on 2017/06/28.
//  Copyright © 2017年 info.tmpla. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController {
        @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var star: UIImageView!

    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var logoCenterY: NSLayoutConstraint!
    @IBOutlet weak var logoWidth: NSLayoutConstraint!

    @IBOutlet weak var logoCenterX: NSLayoutConstraint!
    @IBOutlet weak var starCenterY: NSLayoutConstraint!
    @IBOutlet weak var starCenterX: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func goToMain() {
        performSegue(withIdentifier: "main", sender: nil)
    }
    


    override func viewDidAppear(_ animated: Bool) {
        let duration = 1.0
        CATransaction.begin()
//
        CATransaction.setCompletionBlock { () -> Void in



        }
        
        let ani:CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        ani.duration = 0.5
//        ani.fromValue = 0.0
        ani.toValue = Double.pi
        ani.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        ani.isCumulative = true
        ani.repeatCount = MAXFLOAT
        self.star.layer.add(ani, forKey: "startRotation")
        CATransaction.commit()
//        let api = Api(pairs: ["JPYVND", "USDVND","AUDVND"])
        
        if (Country.loadAll().count == 0) {
            Country.createInitialCountries()
        }
        Country.updateFromApi { 
            self.moveLogo()
            self.moveStar()
            
            
            UIView.animate(withDuration: duration, delay: 0.0,
                           options: .curveEaseIn,
                           animations: {
                            self.star.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                            self.view.layoutIfNeeded()
            }, completion: { (finished: Bool) in
                //
                self.star.layer.removeAllAnimations()
                self.goToMain()
            })

        }

    }
    
    private func moveLogo() {
        // ロゴの移動
        self.view.removeConstraints([self.logoCenterY, self.logoCenterX])
        
        self.view.addConstraints([
            NSLayoutConstraint(
                item: self.logo,
                attribute: .centerY,
                relatedBy: .equal,
                toItem: self.view,
                attribute: .centerY, multiplier: 0.25, constant: 0),
            NSLayoutConstraint(item: self.logo, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1.1, constant: 0)])
        
        self.view.removeConstraint(self.logoWidth)
        self.logo.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.6).isActive = true
    }
    
    private func moveStar() {
        // 星の移動
        self.view.removeConstraints([self.starCenterY, self.starCenterX])
        self.view.addConstraints([
            NSLayoutConstraint(item: self.star, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 0.3, constant: 0)])
        self.view.addConstraint(NSLayoutConstraint(
            item: self.logo,
            attribute: .centerY,
            relatedBy: .equal,
            toItem: self.star,
            attribute: .centerY, multiplier: 1.05, constant: 0))
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
