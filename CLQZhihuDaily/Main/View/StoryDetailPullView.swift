//
//  StoryDetailPullView.swift
//  CLQZhihuDaily
//
//  Created by 崔岚清 on 2017/5/12.
//  Copyright © 2017年 cuilanqing. All rights reserved.
//  story详情页面的上拉、下拉视图

import UIKit
import SnapKit

class StoryDetailPullView: UIView {

    /// label的文字：载入上一篇、载入下一篇、已经是第一篇了 等
    var tipText: String! {
        didSet {
            self.tipLabel.text = self.tipText
        }
    }
    
    /// 指示状态的箭头
    var arrowImg: UIImage! {
        didSet {
            self.arrowImageView.image = self.arrowImg
        }
    }
    
    /// 该view的背景色
    var bgColor: UIColor! {
        didSet {
            self.backgroundColor = self.bgColor
        }
    }
    
    /// label文字颜色
    var textColor: UIColor! {
        didSet {
            self.tipLabel.textColor = self.textColor
        }
    }
    
    /// 是否第一条story
    var isFirstStory: Bool! {
        didSet {
            if self.isFirstStory {
                self.arrowImageView.isHidden = true
                self.tipLabel.snp.updateConstraints({ (make) in
                    make.center.equalTo(self.snp.center)
                    make.height.equalTo(16)
                    make.width.equalTo(110)
                })
            }else {
                self.arrowImageView.isHidden = false
                self.tipLabel.snp.updateConstraints({ (make) in
                    make.centerY.equalTo(self.snp.centerY)
                    make.centerX.equalTo(self.snp.centerX).offset(15)
                    make.height.equalTo(16)
                    make.width.equalTo(80)
                })
            }
        }
    }
    
    var pullTriggered: Bool! = false {
        didSet {
            self.setArrowImageViewAnimation()
        }
    }
    
    private lazy var tipLabel: UILabel = {
        let tmpLabel = UILabel()
        tmpLabel.textAlignment = .center
        tmpLabel.font = UIFont.systemFont(ofSize: 14.0)
        
        return tmpLabel
    }()
    
    lazy var arrowImageView: UIImageView = {
        let tmpImgV = UIImageView()
        tmpImgV.contentMode = .scaleToFill
        
        return tmpImgV
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.tipLabel)
        self.addSubview(self.arrowImageView)
        
        self.tipLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.snp.centerY)
            make.centerX.equalTo(self.snp.centerX).offset(15)
            make.height.equalTo(16)
            make.width.equalTo(80)
        }
        
        self.arrowImageView.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.snp.centerY)
            make.right.equalTo(self.tipLabel.snp.left)
            make.height.equalTo(20)
            make.width.equalTo(15)
        }
    }
    
    private lazy var animation1: CABasicAnimation = {
        let tmp: CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        tmp.duration = 0.2
        tmp.repeatCount = 1
        tmp.fromValue = 0
        tmp.toValue = Double.pi
        tmp.fillMode = kCAFillModeForwards
        tmp.isRemovedOnCompletion = false
        
        return tmp
    }()
    
    private lazy var animation2: CABasicAnimation = {
        let tmp: CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        tmp.duration = 0.2
        tmp.repeatCount = 1
        tmp.fromValue = -Double.pi
        tmp.toValue = 0
        tmp.fillMode = kCAFillModeForwards
        tmp.isRemovedOnCompletion = false
        
        return tmp
    }()
    
    func setArrowImageViewAnimation() {
        self.arrowImageView.layer.removeAllAnimations()
        
        if self.pullTriggered {
            self.arrowImageView.layer.add(self.animation1, forKey: "arrowImageViewRotate1")
        }else {
            self.arrowImageView.layer.add(self.animation2, forKey: "arrowImageViewRotate2")
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
