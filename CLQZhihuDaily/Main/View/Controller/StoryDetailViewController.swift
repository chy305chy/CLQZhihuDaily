//
//  StoryDetailViewController.swift
//  CLQZhihuDaily
//
//  Created by 崔岚清 on 2017/5/9.
//  Copyright © 2017年 cuilanqing. All rights reserved.
//  story详情视图控制器

import UIKit
import ReactiveSwift
import ReactiveCocoa
import Result

class StoryDetailViewController: UIViewController, UIScrollViewDelegate {
    
    let scrollViewOffsetTop: CGFloat = 84.0
    var titleImageViewOriginalHeight: CGFloat = 0.0
    
    lazy var titleImageView: UIImageView = {
        let tmpImgV: UIImageView = UIImageView(frame: CGRect.init(x: 0, y: self.scrollViewOffsetTop, width: self.view.frame.size.width, height: 100))
        tmpImgV.backgroundColor = UIColor.blue
        tmpImgV.contentMode = .scaleAspectFill
        tmpImgV.layer.masksToBounds = true
        return tmpImgV
    }()
    
    lazy var storyDetailView: StoryDetailView = {
        let tmpView: StoryDetailView = StoryDetailView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        tmpView.scrollView.contentInset = UIEdgeInsetsMake(-self.scrollViewOffsetTop, 0, 0, 0)
        tmpView.scrollView.delegate = self
        return tmpView
    }()
    
    var storyViewModel: StoryViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.lightGray
        self.automaticallyAdjustsScrollViewInsets = false
        
        // Do any additional setup after loading the view.
        self.view.addSubview(self.storyDetailView)
        
        /// KVO
        DynamicProperty<StoryDetailModel>(object: self.storyViewModel!, keyPath: "storyDetailModel").producer.startWithSignal { (observer, disposable) in
            observer.observeValues({[weak self] (value) in
                guard let strongSelf = self else { return }
                if value != nil {
                    let model = value!

                    do {
                        let data = try Data.init(contentsOf: URL(string: model.css)!)
                        let cssContent = String(data: data, encoding: String.Encoding.utf8)
                        let bodyPadding = 736 == UIScreen.main.bounds.size.height ? 130 : 100
                        let customCss = String(format: "body {padding-top:%ldpx;}", bodyPadding)
                        let htmlFormatString: String = "<html><head><style>%@</style><style type='text/css'>%@</style></head><body>%@</body></html>"
                        let htmlString = String(format: htmlFormatString, cssContent!, customCss, model.body)
                        strongSelf.storyDetailView.loadHTMLString(htmlString, baseURL: nil)
                        
                        strongSelf.storyViewModel?.fetchStoryDetailTitleImage(withUrl: model.image)
                        
                        var frame = strongSelf.titleImageView.frame
                        strongSelf.titleImageViewOriginalHeight = CGFloat(bodyPadding) + 205 - strongSelf.scrollViewOffsetTop
                        frame.size.height = strongSelf.titleImageViewOriginalHeight
                        strongSelf.titleImageView.frame = frame
                        strongSelf.storyDetailView.scrollView.addSubview(strongSelf.titleImageView);
                    }catch {
                        print(error)
                    }
                    
                }
            })
        }
        
        DynamicProperty<UIImage>(object: self.storyViewModel!, keyPath: "detailStoryTitleImage").producer.startWithSignal { (observer, disposable) in
            observer.observeValues({[weak self] (value) in
                guard let strongSelf = self else { return }
                if value != nil {
                    strongSelf.titleImageView.image = value
                }
            })
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        if offsetY <= 0 {
            scrollView.contentOffset = CGPoint(x: 0, y: 0)
        }
        
        var frame = self.titleImageView.frame
        frame.origin.y = offsetY
        frame.size.height = self.titleImageViewOriginalHeight + (self.scrollViewOffsetTop - offsetY)
        self.titleImageView.frame = frame
        
        print("%f", offsetY)
    }

//    override var prefersStatusBarHidden: Bool {
//        return true
//    }
    
    deinit {
        print("StoryDetailViewController销毁了")
    }

}
