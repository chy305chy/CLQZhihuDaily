//
//  ViewController.swift
//  CLQZhihuDaily
//
//  Created by 崔岚清 on 2017/2/10.
//  Copyright © 2017年 cuilanqing. All rights reserved.
//  根容器，本身不包含任何UI元素

import UIKit
import ReactiveCocoa
import ReactiveSwift
import Result

class ViewController: UIViewController {
    
    /// 主界面的点击手势，用户在左侧菜单划出后点击关闭
    var tapGesture: UITapGestureRecognizer!
    
    var mainNavigationController: MainNavigationController!
    
    /// 首页的主要视图
    var mainViewController: MainViewController!
    
    /// 首页的左侧视图
    var leftViewController: LeftViewController!
    
    /// self.view和mainView的中心点在x轴上的距离
    var distance: CGFloat = 0.0
    
    var mainView: UIView!
    
    var leftViewShowed: Bool = false {
        didSet {
            if self.leftViewShowed {
                mainViewController.navigationItem.leftBarButtonItem?.action = #selector(ViewController.showMain)
            }else {
                mainViewController.navigationItem.leftBarButtonItem?.action = #selector(ViewController.showLeft)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        /* 去除左侧视图菜单 */
        leftViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "leftViewController") as! LeftViewController
        
        /* 初始化侧边栏的frame */
        leftViewController.view.frame = CGRect(x: -Common.leftViewWidth, y: 0, width: Common.leftViewWidth, height: self.view.frame.height)
        
        self.view.addSubview(leftViewController.view)
        
        mainView = UIView(frame: self.view.frame)
        
        mainNavigationController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mainNavController") as! MainNavigationController
        
        mainViewController = mainNavigationController.viewControllers.first as! MainViewController
        
        mainView.addSubview(mainNavigationController.view)
        
        self.view.addSubview(mainView)
        
        /* 给主视图绑定panGesture */
        let panGesture: UIPanGestureRecognizer = mainViewController.panGesture
        panGesture.addTarget(self, action: #selector(ViewController.pan(_:)))
        mainView.addGestureRecognizer(panGesture)
        
        /* 单击收起左侧菜单 */
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(ViewController.showMain))
    }
    
    /// 展示左侧视图
    func showLeft() -> Void {
        mainView.addGestureRecognizer(tapGesture)
        distance = Common.leftViewWidth
        doAnimation("left")
        self.leftViewShowed = true
    }
    
    /// 展示主视图
    func showMain() -> Void {
        mainView.removeGestureRecognizer(tapGesture)
        distance = 0
        doAnimation("main")
        self.leftViewShowed = false
    }
    
    /// 响应UIPanGestureRecognizer事件
    ///
    /// - Parameter recognizer:
    func pan(_ recognizer: UIPanGestureRecognizer) -> Void {
        let x = recognizer.translation(in: self.view).x
        let trueDistance = distance + x
        
        /* pan手势结束时，激活自动停靠 */
        if recognizer.state == UIGestureRecognizerState.ended {
            if trueDistance > Common.leftViewWidth / 2 {
                /* 向右滑动大于临界点，展示侧边栏 */
                showLeft()
            }else {
                showMain()
            }
            return
        }
        
        /* 同步移动view */
        recognizer.view?.center = CGPoint(x: self.view.center.x + trueDistance, y: self.view.center.y)
        self.leftViewController.view.center.x = (recognizer.view?.frame.origin.x)! - Common.leftViewWidth / 2
        
        /* 设置view左右滑动时移动的最大距离 */
        if (recognizer.view?.frame.origin.x)! >= Common.leftViewWidth {
            /* 右滑 */
            recognizer.view?.center = CGPoint(x: self.view.center.x + Common.leftViewWidth, y: self.view.center.y)
            self.leftViewController.view.center.x = Common.leftViewWidth / 2
        }
        
        if (recognizer.view?.frame.origin.x)! <= 0 {
            /* 左滑 */
            recognizer.view?.center = CGPoint(x: self.view.center.x, y: self.view.center.y)
            self.leftViewController.view.center.x = -Common.leftViewWidth / 2
        }
    }
    
    /// 执行动画
    ///
    /// - Parameter showWhat: 显示侧边栏视图或主视图
    func doAnimation(_ showWhat: String) -> Void {
        UIView.animate(withDuration: 0.3, delay: 0, options: UIViewAnimationOptions(), animations: { 
            if showWhat == "main" {
                self.mainView.center = CGPoint(x: self.view.center.x, y: self.view.center.y)
                self.leftViewController.view.center = CGPoint(x: -(Common.leftViewWidth / 2), y: self.view.center.y)
            }
            if showWhat == "left" {
                self.mainView.center = CGPoint(x: self.view.center.x + Common.leftViewWidth, y: self.view.center.y)
                self.leftViewController.view.center = CGPoint(x: Common.leftViewWidth / 2, y: self.view.center.y)
            }
        })
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

