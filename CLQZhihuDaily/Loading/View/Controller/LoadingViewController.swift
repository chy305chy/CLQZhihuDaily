//
//  LoadingViewController.swift
//  CLQZhihuDaily
//
//  Created by 崔岚清 on 2017/2/16.
//  Copyright © 2017年 cuilanqing. All rights reserved.
//  加载页面

import UIKit
import ReactiveSwift
import ReactiveCocoa
import Result
import SnapKit

class LoadingViewController: UIViewController {
    
    @IBOutlet weak var startImageView: UIImageView!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var authorLabel: UILabel!
    
//    override var prefersStatusBarHidden: Bool {
//        return true
//    }

    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.isStatusBarHidden = true
        // Do any additional setup after loading the view.
        layoutSubview()
        
        // KVO
        DynamicProperty<UIImage>(object: LoadingViewModel.sharedLoadingViewModel, keyPath: "startImage").producer.startWithSignal { (observer, disposable) in
            observer.observeValues({ (value) in
                if value != nil {
                    self.authorLabel.text = LoadingViewModel.sharedLoadingViewModel.startImageAuthor
                    self.startImageView.image = value
                    UIView.animate(withDuration: 1.5, animations: {
                        self.logoImageView.alpha = 1.0
                        self.startImageView.alpha = 1.0
                        self.authorLabel.alpha = 1.0
                    }, completion: { (finished) in
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + DispatchTimeInterval.milliseconds(3000), execute: {
                            UIApplication.shared.keyWindow?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "viewController")
                        })
                    })
                }
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /// 布局
    func layoutSubview() {
        startImageView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view.snp.edges)
        }
        
        logoImageView.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view.snp.centerX)
            make.width.equalTo(125)
            make.height.equalTo(45)
            make.bottom.equalTo(self.view.snp.bottom).offset(-30)
        }
        
        authorLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view.snp.centerX)
            make.width.equalTo(100)
            make.height.equalTo(20)
            make.bottom.equalTo(logoImageView.snp.top).offset(-15)
        }
    }
    
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//        return .lightContent
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
