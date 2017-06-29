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
        let ani:CABasicAnimation = CABasicAnimation(keyPath: "transform.rotarion")
        ani.duration = 3.0
        ani.toValue = M_PI / 2.0
        ani.repeatCount = MAXFLOAT
        ani.isCumulative = true
        star.layer.add(ani, forKey: "startRotation")
        ani.fini

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
