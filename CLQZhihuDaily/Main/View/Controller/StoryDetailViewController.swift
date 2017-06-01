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

class StoryDetailViewController: UIViewController, UIScrollViewDelegate, UIWebViewDelegate {
    
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
        
        return tmpLabel
    }()
    
    lazy var storySubtitleLabel: UILabel = {
        let tmpLabel = UILabel()
        tmpLabel.font = UIFont.systemFont(ofSize: 10.0)
        tmpLabel.textColor = UIColor(colorLiteralRed: 200.0/255.0, green: 200.0/255.0, blue: 200.0/255.0, alpha: 1.0)
        tmpLabel.textAlignment = .right
        
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
        let tmpView: StoryDetailView = StoryDetailView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height - 45))
        tmpView.scrollView.contentInset = UIEdgeInsetsMake(-self.scrollViewOffsetTop, 0, 0, 0)
        tmpView.scrollView.delegate = self
        tmpView.scrollView.backgroundColor = UIColor.white
        tmpView.delegate = self
        
        return tmpView
    }()
    
    var storyViewModel: StoryViewModel?
    
    /// 下拉视图
    lazy var topPullView: StoryDetailPullView = {
        let tmpPullView: StoryDetailPullView = StoryDetailPullView(frame: CGRect(x: 0, y: -self.scrollViewOffsetTop, width: self.view.frame.size.width, height: self.scrollViewOffsetTop))
        tmpPullView.tipText = "加载上一篇"
        tmpPullView.arrowImg = UIImage(named: "preStoryArrow")
        tmpPullView.bgColor = UIColor.clear
        tmpPullView.textColor = UIColor.white
        
        if self.storyViewModel!.selectedIndexPath.row==0 && self.storyViewModel!.selectedIndexPath.section == 0 {
            tmpPullView.tipText = "已经是第一篇了"
            tmpPullView.isFirstStory = true
        }
        
        return tmpPullView
    }()
    
    /// 上拉视图
    lazy var bottomPullView: StoryDetailPullView = {
        let tmpPullView: StoryDetailPullView = StoryDetailPullView(frame: CGRect.init(x: 0, y: 2*self.view.frame.size.height, width: self.view.frame.size.width, height: self.scrollViewOffsetTop))
        tmpPullView.tipText = "加载下一篇"
        tmpPullView.arrowImg = UIImage(named: "nextStoryArrow")
        tmpPullView.bgColor = UIColor.white
        tmpPullView.textColor = UIColor(red: 219.0/255.0, green: 219.0/255.0, blue: 219.0/255.0, alpha: 1.0)
        
        return tmpPullView
    }()
    
    /// 底部评论、赞等视图
    lazy var bottomActionView: StoryDetailBottomView = {
        let tmpBottomView: StoryDetailBottomView = StoryDetailBottomView(frame: CGRect.init(x: 0, y: self.view.frame.size.height - 45, width: self.view.frame.size.width, height: 45))
        tmpBottomView.backButton.addTarget(self, action: #selector(backToMain), for: .touchUpInside)
        tmpBottomView.nextStoryButton.addTarget(self, action: #selector(loadNextStory), for: .touchUpInside)
        tmpBottomView.voteButton.addTarget(self, action: #selector(vote), for: .touchUpInside)
        tmpBottomView.commentButton.addTarget(self, action: #selector(comment), for: .touchUpInside)
        
        return tmpBottomView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.automaticallyAdjustsScrollViewInsets = false
        
        // Do any additional setup after loading the view.
        self.view.addSubview(self.storyDetailView)
        self.view.addSubview(self.topPullView)
        self.storyDetailView.scrollView.addSubview(self.bottomPullView)
        self.view.addSubview(self.bottomActionView)
        
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
        
        DynamicProperty<StoryDetailExtraModel>(object: self.storyViewModel!, keyPath: "storyDetailExtraModel").producer.startWithSignal { (observer, disposable) in
            observer.observeValues({[weak self] (value) in
                guard let strongSelf = self else { return }
                if value != nil {
                    strongSelf.bottomActionView.voteCount = value?.popularity
                    strongSelf.bottomActionView.commentCount = value?.comments
                }
            })
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        var frame = self.bottomPullView.frame
        frame.origin.y = self.storyDetailView.scrollView.contentSize.height
        self.bottomPullView.frame = frame
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
        
        var frame = self.topPullView.frame
        
        // 下拉控件
        if offsetY >= 0 {
            frame.origin.y = -offsetY
            self.topPullView.frame = frame
            if offsetY == 0 {
                if !self.topPullView.pullTriggered {
                    self.topPullView.pullTriggered = true
                }
            }else {
                if self.topPullView.pullTriggered {
                    self.topPullView.pullTriggered = false
                }
            }
        }
        
        // 上拉控件
        if offsetY >= scrollView.contentSize.height - UIScreen.main.bounds.size.height + 45 {
            if offsetY >=  scrollView.contentSize.height - UIScreen.main.bounds.size.height + 45 + self.scrollViewOffsetTop{
                if !self.bottomPullView.pullTriggered {
                    self.bottomPullView.pullTriggered = true
                }
            }else {
                if self.bottomPullView.pullTriggered {
                    self.bottomPullView.pullTriggered = false
                }
            }
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY = scrollView.contentOffset.y
        
        let selectedIndexPath: IndexPath! = self.storyViewModel!.selectedIndexPath
        if offsetY <= 0 {
            // 下拉加载上一条
            if !(selectedIndexPath.row == 0 && selectedIndexPath.section == 0) {
                // 非第一条story
                var tmpIndexPath: IndexPath!
                if selectedIndexPath!.row - 1 < 0 {
                    let rowCount = self.storyViewModel!.listStoryModels[selectedIndexPath.section - 1].count
                    tmpIndexPath = IndexPath(row: rowCount-1, section: selectedIndexPath.section - 1)
                }else {
                    tmpIndexPath = IndexPath(row: selectedIndexPath!.row - 1, section: selectedIndexPath!.section)
                }
                
                let model = self.storyViewModel!.listStoryModels[tmpIndexPath.section][tmpIndexPath.row]
                let storyId = model.storyId
                model.readed = true
                
                self.changeAndLoadNextStoryDetailView(withId: storyId!, type: "previous", complete: {
                    self.storyViewModel!.selectedIndexPath = tmpIndexPath
                    self.topPullView.frame = CGRect(x: 0, y: -self.scrollViewOffsetTop, width: self.view.frame.size.width, height: self.scrollViewOffsetTop)
                    self.view.bringSubview(toFront: self.topPullView)
                    
                    // 第一篇
                    if tmpIndexPath.section == 0 && tmpIndexPath.row == 0 {
                        self.topPullView.tipText = "已经是第一篇了"
                        self.topPullView.isFirstStory = true
                    }
                })
            }
        }
        
        if offsetY >= scrollView.contentSize.height - self.view.frame.size.height + scrollViewOffsetTop {
            self.loadNextStory()
        }
    }
    
    func backToMain() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func loadNextStory() {
        let selectedIndexPath: IndexPath! = self.storyViewModel!.selectedIndexPath
        // 上拉加载下一条
        var tmpIndexPath: IndexPath!
        if selectedIndexPath.row + 1 > self.storyViewModel!.listStoryModels[selectedIndexPath.section].count {
            // 到下一个section
            tmpIndexPath = IndexPath(row: 0, section: selectedIndexPath.section + 1)
        }else {
            tmpIndexPath = IndexPath(row: selectedIndexPath.row + 1, section: selectedIndexPath.section)
        }
        
        let model = self.storyViewModel!.listStoryModels[tmpIndexPath.section][tmpIndexPath.row]
        let storyId = model.storyId
        model.readed = true
        
        self.changeAndLoadNextStoryDetailView(withId: storyId!, type: "next", complete: {
            self.storyViewModel!.selectedIndexPath = tmpIndexPath
            // 完成时要重置statusBar的背景色和style
            self.setStatusBarBackgroundColor(color: UIColor.clear)
            UIApplication.shared.statusBarStyle = .lightContent
            
            self.topPullView.frame = CGRect(x: 0, y: -self.scrollViewOffsetTop, width: self.view.frame.size.width, height: self.scrollViewOffsetTop)
            self.view.bringSubview(toFront: self.topPullView)
            
            if !(tmpIndexPath.row == 0 && tmpIndexPath.section == 0) {
                self.topPullView.tipText = "加载上一篇"
                self.topPullView.isFirstStory = false
            }
        })
    }
    
    func vote() {
        let alert: UIAlertController = UIAlertController(title: nil, message: String(format: "收到了%d个赞", self.storyViewModel!.storyDetailExtraModel!.popularity), preferredStyle: .alert)
        let alertAction: UIAlertAction = UIAlertAction(title: "确定", style: .default, handler: nil)
        alert.addAction(alertAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func comment() {
        let alert: UIAlertController = UIAlertController(title: nil, message: String(format: "收到了%d个评论", self.storyViewModel!.storyDetailExtraModel!.comments), preferredStyle: .alert)
        let alertAction: UIAlertAction = UIAlertAction(title: "确定", style: .default, handler: nil)
        alert.addAction(alertAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    /// 加载上一篇或下一篇story并切换
    ///
    /// - Parameters:
    ///   - withId: 要加载的storyId
    ///   - type: “previous”：上一篇，“next”：下一篇
    ///   - complete: 完成时的回调
    func changeAndLoadNextStoryDetailView(withId: UInt64, type: String, complete: @escaping () -> Void) {
        self.storyDetailView.isUserInteractionEnabled = false
        var tmpView: StoryDetailView!
        if type == "previous" {
            // 加载上一篇
            tmpView = StoryDetailView(frame: CGRect(x: 0, y: -(self.view.frame.size.height-45), width: self.view.frame.size.width, height: self.view.frame.size.height - 45))
        }else {
            // 加载下一篇
            tmpView = StoryDetailView(frame: CGRect(x: 0, y: self.view.frame.size.height-45, width: self.view.frame.size.width, height: self.view.frame.size.height - 45))
        }
        
        tmpView.scrollView.contentInset = UIEdgeInsetsMake(-self.scrollViewOffsetTop, 0, 0, 0)
        tmpView.scrollView.delegate = self
        tmpView.isUserInteractionEnabled = false
        tmpView.scrollView.backgroundColor = UIColor.white
        tmpView.delegate = self
        self.view.addSubview(tmpView)
        self.view.sendSubview(toBack: tmpView)
        
        let previousStoryDetailView = self.storyDetailView
        self.storyDetailView = tmpView
        self.storyViewModel!.fetchDetailStory(withId: withId)
        self.storyViewModel!.fetchDetailStoryExtraInfo(withId: withId)
        var frame = previousStoryDetailView.frame
        
        if type == "previous" {
            // 加载上一篇
            frame.origin.y += UIScreen.main.bounds.size.height-45
        }else {
            // 加载下一篇
            frame.origin.y -= UIScreen.main.bounds.size.height-45
        }
        
        UIView.animate(withDuration: 0.3, animations: {
            previousStoryDetailView.frame = frame
            tmpView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height-45)
        }, completion: { (finished) in
            previousStoryDetailView.removeFromSuperview()
            tmpView.isUserInteractionEnabled = true
            tmpView.scrollView.addSubview(self.bottomPullView)
            complete()
        })
    }

    func setStatusBarBackgroundColor(color: UIColor) {
        let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
        
        if statusBar.responds(to: #selector(setter: UIView.backgroundColor)) {
            UIView.animate(withDuration: 0.2, animations: {
                statusBar.backgroundColor = color
            })
        }
    }
    
    deinit {
        self.storyViewModel?.detailStoryTitleImage = nil
        self.storyViewModel?.storyDetailModel = nil
        print("StoryDetailViewController销毁了")
    }

}
