//
//  MainNavigationController.swift
//  CLQZhihuDaily
//
//  Created by 崔岚清 on 2017/2/22.
//  Copyright © 2017年 cuilanqing. All rights reserved.
//

import UIKit

class MainNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        UIApplication.shared.isStatusBarHidden = false
        self.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
//        setNavigationBarTransparent()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setNavigationBarTransparent() {
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.isTranslucent = true
        self.navigationBar.tintColor = UIColor.white
        let color = UIColor.clear
        let rect = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 64)
        
        UIGraphicsBeginImageContext(rect.size)
        let ref = UIGraphicsGetCurrentContext()
        ref?.setFillColor(color.cgColor)
        ref?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        self.navigationBar.setBackgroundImage(image, for: .default)
    }
    
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//        let topVC = self.topViewController!
//        return topVC.preferredStatusBarStyle
//    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
