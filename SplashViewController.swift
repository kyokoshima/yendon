//
//  SplashViewController.swift
//  YenDon
//
//  Created by 横島健一 on 2017/06/28.
//  Copyright © 2017年 info.tmpla. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController {
    @IBOutlet weak var star: UIImageView!

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
        CATransaction.begin()
//
        CATransaction.setCompletionBlock { () -> Void in
            self.star.layer.removeAllAnimations()
            self.goToMain()
        }
        
        let ani:CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation")
        ani.duration = 2.0
        ani.fromValue = 0.0
        ani.toValue = Double.pi * 5
        ani.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        ani.isCumulative = true
        self.star.layer.add(ani, forKey: "startRotation")
        CATransaction.commit()
        

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
