//
//  AccountLoginView.swift
//  CLQZhihuDaily
//
//  Created by 崔岚清 on 2017/5/15.
//  Copyright © 2017年 cuilanqing. All rights reserved.
//  侧边栏登录view

import UIKit
import SnapKit

class AccountLoginView: UIControl {
    
    private lazy var userHeadIconImageView: UIImageView = {
        let tmpImgV = UIImageView()
        tmpImgV.image = UIImage(named: "Dark_Menu_Avatar")
        tmpImgV.frame = CGRect(x: 15, y: 30, width: 35, height: 35)
        
        return tmpImgV
    }()
    
    lazy var loginTipLabel: UILabel = {
        let tmpLabel = UILabel()
        tmpLabel.text = "请登录"
        tmpLabel.font = UIFont.systemFont(ofSize: 15.0)
        tmpLabel.textAlignment = .center
        tmpLabel.textColor = Common.SIDEBAR_TEXTCOLOR
        
        return tmpLabel
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clear
        self.addSubview(self.userHeadIconImageView)
        self.addSubview(self.loginTipLabel)
        
        loginTipLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.userHeadIconImageView.snp.centerY)
            make.left.equalTo(self.userHeadIconImageView.snp.right).offset(10)
            make.width.equalTo(55)
            make.height.equalTo(17)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
