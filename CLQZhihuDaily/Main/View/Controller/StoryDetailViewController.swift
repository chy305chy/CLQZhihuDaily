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
import SnapKit

class StoryDetailViewController: UIViewController, UIScrollViewDelegate {
    
    let scrollViewOffsetTop: CGFloat = 84.0
    var titleImageViewOriginalHeight: CGFloat = 0.0
    let titleLabelLeftMargin: CGFloat = 20.0   // 主标题label与父视图左右边界的间距
    let labelGap: CGFloat = 10.0               // 主标题label与副标题label的间距
    let titleLabelHeight: CGFloat = 53.0       // 主标题label的高度
    let subtitleLabelHeight: CGFloat = 12.0    // 副标题label的高度
    
    lazy var gradientView: GradientView = {
        let tmpView: GradientView = GradientView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 0))
        
        return tmpView
    }()
    
    lazy var storyTitleLabel: UILabel = {
        let tmpLabel = UILabel()
        tmpLabel.font = UIFont.boldSystemFont(ofSize: 21.0)
        tmpLabel.textColor = UIColor.white
        tmpLabel.textAlignment = .left
        tmpLabel.numberOfLines = 2
        tmpLabel.lineBreakMode = .byWordWrapping
//        tmpLabel.text = "我是测试测试标题，哈哈哈哈哈哈哈哈"
        
        return tmpLabel
    }()
    
    lazy var storySubtitleLabel: UILabel = {
        let tmpLabel = UILabel()
        tmpLabel.font = UIFont.systemFont(ofSize: 10.0)
        tmpLabel.textColor = UIColor(colorLiteralRed: 200.0/255.0, green: 200.0/255.0, blue: 200.0/255.0, alpha: 1.0)
        tmpLabel.textAlignment = .right
//        tmpLabel.text = "图片：《名侦探柯南》"
        
        return tmpLabel
    }()
    
    lazy var titleImageView: UIImageView = {
        let tmpImgV: UIImageView = UIImageView(frame: CGRect.init(x: 0, y: self.scrollViewOffsetTop, width: self.view.frame.size.width, height: 100))
        tmpImgV.backgroundColor = UIColor.white
        tmpImgV.contentMode = .scaleAspectFill
        tmpImgV.layer.masksToBounds = true
        tmpImgV.addSubview(self.gradientView)
        tmpImgV.addSubview(self.storyTitleLabel)
        tmpImgV.addSubview(self.storySubtitleLabel)
        
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
                        
                        var frame2 = strongSelf.gradientView.frame
                        frame2.size.height = CGFloat(bodyPadding) + 205
                        strongSelf.gradientView.frame = frame2
                        
                        strongSelf.storyTitleLabel.frame = CGRect(x: strongSelf.titleLabelLeftMargin, y: strongSelf.titleImageView.frame.size.height - strongSelf.titleLabelHeight - 2*strongSelf.labelGap-strongSelf.subtitleLabelHeight, width: strongSelf.titleImageView.frame.size.width - 3*strongSelf.titleLabelLeftMargin, height: strongSelf.titleLabelHeight)
                        strongSelf.storySubtitleLabel.frame = CGRect(x: strongSelf.titleLabelLeftMargin, y: strongSelf.titleImageView.frame.size.height - strongSelf.labelGap - strongSelf.subtitleLabelHeight, width: strongSelf.titleImageView.frame.size.width - 2*strongSelf.titleLabelLeftMargin, height: strongSelf.subtitleLabelHeight)
                        
                        strongSelf.storyTitleLabel.text = model.title
                        strongSelf.storySubtitleLabel.text = "图片：".appending(model.imageSource)
                    }catch {
                        print(error)
                    }
                    
                }
            })
        }
        
        DynamicProperty<UIImage>(object: self.storyViewModel!, keyPath: "detailStoryTitleImage").producer.startWithSignal { (observer, disposable) in
            observer.observeValues({[weak self] (value) in
                guard let strongSelf = self else { return }
                strongSelf.titleImageView.image = value
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
        
        if offsetY <= scrollViewOffsetTop && offsetY >= 0 {
            var frame = self.titleImageView.frame
            frame.origin.y = offsetY
            frame.size.height = self.titleImageViewOriginalHeight + (self.scrollViewOffsetTop - offsetY)
            self.titleImageView.frame = frame
            self.storyTitleLabel.frame = CGRect(x: titleLabelLeftMargin, y: self.titleImageView.frame.size.height - titleLabelHeight - 2*labelGap-subtitleLabelHeight, width: self.titleImageView.frame.size.width - 3*titleLabelLeftMargin, height: titleLabelHeight)
            self.storySubtitleLabel.frame = CGRect(x: self.titleLabelLeftMargin, y: self.titleImageView.frame.size.height - self.labelGap - self.subtitleLabelHeight, width: self.titleImageView.frame.size.width - 2*self.titleLabelLeftMargin, height: self.subtitleLabelHeight)
        }
        
        // 向上滑动到一定距离时，改变statusBar的透明度
        if offsetY >= self.titleImageViewOriginalHeight + self.scrollViewOffsetTop - 20 {
            self.setStatusBarBackgroundColor(color: UIColor.white)
            UIApplication.shared.statusBarStyle = .default
        }else {
            self.setStatusBarBackgroundColor(color: UIColor.clear)
            UIApplication.shared.statusBarStyle = .lightContent
        }
    }

    func setStatusBarBackgroundColor(color: UIColor) {
        let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
        
        if statusBar.responds(to: #selector(setter: UIView.backgroundColor)) {
            UIView.animate(withDuration: 0.2, animations: {
                statusBar.backgroundColor = color
            })
        }
    }
    
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//        if self.isStatusBarLightContent {
//            return .lightContent
//        }
//        return .default
//    }
    
    deinit {
        self.storyViewModel?.detailStoryTitleImage = nil
        self.storyViewModel?.storyDetailModel = nil
        print("StoryDetailViewController销毁了")
    }

}
