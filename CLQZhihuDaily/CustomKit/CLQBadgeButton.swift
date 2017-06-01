//
//  CLQBadgeButton.swift
//  CLQZhihuDaily
//
//  Created by 崔岚清 on 2017/6/1.
//  Copyright © 2017年 cuilanqing. All rights reserved.
//

import UIKit
import SnapKit

enum CLQBadgeButtonType {
    case vote
    case comment
}

class CLQBadgeButton: UIControl {

    var badgeText: String! {
        didSet {
            self.badgeTextLabel.text = self.badgeText
        }
    }
    
    var buttonImage: UIImage! {
        didSet {
            self.buttonImageView.image = self.buttonImage
            self.buttonImageView.snp.updateConstraints { (make) in
                make.center.equalTo(self.snp.center)
                make.width.equalTo(self.buttonImage.size.width)
                make.height.equalTo(self.buttonImage.size.height)
            }
        }
    }
    
    var buttonType: CLQBadgeButtonType! {
        didSet {
            if self.buttonType == .comment {
                self.badgeTextLabel.textColor = UIColor.white
                self.badgeTextLabel.snp.makeConstraints({ (make) in
                    make.top.equalTo(self.buttonImageView.snp.top).offset(8)
                    make.right.equalTo(self.buttonImageView.snp.right).offset(-12)
                    make.width.equalTo(20)
                    make.height.equalTo(10)
                })
            }else {
                self.badgeTextLabel.textColor = UIColor(colorLiteralRed: 158.0/255.0, green: 158.0/255.0, blue: 158.0/255.0, alpha: 1.0)
                self.badgeTextLabel.snp.makeConstraints({ (make) in
                    make.top.equalTo(self.buttonImageView.snp.top).offset(5)
                    make.left.equalTo(self.buttonImageView.snp.right).offset(-25)
                    make.width.equalTo(20)
                    make.height.equalTo(10)
                })
            }
        }
    }
    
    private lazy var buttonImageView: UIImageView = {
        let tmpImageView: UIImageView = UIImageView()
        
        return tmpImageView
    }()
    
    private lazy var badgeTextLabel: UILabel = {
        let tmpLabel = UILabel()
        tmpLabel.font = UIFont.systemFont(ofSize: 8.0)
        tmpLabel.textAlignment = .center
        tmpLabel.isOpaque = false
        
        return tmpLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.buttonImageView)
        self.addSubview(self.badgeTextLabel)
        
        self.buttonImageView.snp.makeConstraints { (make) in
            make.center.equalTo(self.snp.center)
            make.width.equalTo(30)
            make.height.equalTo(30)
        }
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
