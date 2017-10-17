//
//  StoryDetailBottomView.swift
//  CLQZhihuDaily
//
//  Created by 崔岚清 on 2017/6/1.
//  Copyright © 2017年 cuilanqing. All rights reserved.
//  详情页底部视图：包括下一篇、返回、赞、评论等功能

import UIKit
import SnapKit

class StoryDetailBottomView: UIView {
    
    var voteCount: NSInteger! {
        didSet {
            let voteCountStr = String(format: "%d", self.voteCount)
            self.voteButton.badgeText = voteCountStr
        }
    }
    
    var commentCount: NSInteger! {
        didSet {
            let commentCountStr = String(format: "%d", self.commentCount)
            self.commentButton.badgeText = commentCountStr
        }
    }
    
    /// 返回button
    lazy var backButton: UIButton = {
        let tmpButton = UIButton()
        tmpButton.setImage(UIImage(named: "News_Navigation_Arrow"), for: .normal)
        tmpButton.setImage(UIImage(named: "News_Navigation_Arrow_Highlight"), for: .highlighted)
        
        return tmpButton
    }()
    
    /// 下一条story
    lazy var nextStoryButton: UIButton = {
        let tmpButton = UIButton()
        tmpButton.setImage(UIImage(named: "News_Navigation_Next"), for: .normal)
        tmpButton.setImage(UIImage(named: "News_Navigation_Next_Highlight"), for: .highlighted)
        
        return tmpButton
    }()
    
    /// 分享
    lazy var shareStoryButton: UIButton = {
        let tmpButton = UIButton()
        tmpButton.setImage(UIImage(named: "News_Navigation_Share"), for: .normal)
        tmpButton.setImage(UIImage(named: "News_Navigation_Share_Highlight"), for: .highlighted)
        
        return tmpButton
    }()
    
    lazy var voteButton: CLQBadgeButton = {
        let tmpButton = CLQBadgeButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        tmpButton.buttonImage = UIImage(named: "News_Navigation_Vote")
        tmpButton.buttonType = .vote
        
        return tmpButton
    }()
    
    lazy var commentButton: CLQBadgeButton = {
        let tmpButton = CLQBadgeButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        tmpButton.buttonImage = UIImage(named: "News_Navigation_Comment")
        tmpButton.buttonType = .comment
        
        return tmpButton
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        
        self.addSubview(self.backButton)
        self.addSubview(self.nextStoryButton)
        self.addSubview(self.voteButton)
        self.addSubview(self.shareStoryButton)
        self.addSubview(self.commentButton)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // 添加顶部阴影
        let shadowPath: UIBezierPath = UIBezierPath()
        shadowPath.move(to: CGPoint(x: 0, y: 0))
        shadowPath.addLine(to: CGPoint(x: self.frame.size.width, y: 0))
        shadowPath.addLine(to: CGPoint(x: self.frame.size.width, y: self.frame.size.height))
        shadowPath.addLine(to: CGPoint(x: 0, y: self.frame.size.height))
        shadowPath.addLine(to: CGPoint(x: 0, y: 0))
        self.layer.shadowPath = shadowPath.cgPath
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowRadius = 1.0
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowOpacity = 0.6
        
        self.backButton.snp.makeConstraints { (make) in
            make.top.equalTo(self.snp.top)
            make.bottom.equalTo(self.snp.bottom)
            make.left.equalTo(self.snp.left)
            make.width.equalTo(self.frame.size.width/5)
        }
        
        self.nextStoryButton.snp.makeConstraints { (make) in
            make.top.equalTo(self.snp.top)
            make.bottom.equalTo(self.snp.bottom)
            make.left.equalTo(self.backButton.snp.right)
            make.width.equalTo(self.frame.size.width/5)
        }
        
        self.voteButton.snp.makeConstraints { (make) in
            make.top.equalTo(self.snp.top)
            make.bottom.equalTo(self.snp.bottom)
            make.left.equalTo(self.nextStoryButton.snp.right)
            make.width.equalTo(self.frame.size.width/5)
        }
        
        self.shareStoryButton.snp.makeConstraints { (make) in
            make.top.equalTo(self.snp.top)
            make.bottom.equalTo(self.snp.bottom)
            make.left.equalTo(self.voteButton.snp.right)
            make.width.equalTo(self.frame.size.width/5)
        }
        
        self.commentButton.snp.makeConstraints { (make) in
            make.top.equalTo(self.snp.top)
            make.bottom.equalTo(self.snp.bottom)
            make.left.equalTo(self.shareStoryButton.snp.right)
            make.width.equalTo(self.frame.size.width/5)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
