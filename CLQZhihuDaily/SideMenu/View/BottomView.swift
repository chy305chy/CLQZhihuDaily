//
//  BottomView.swift
//  CLQZhihuDaily
//
//  Created by cuilanqing on 2017/5/16.
//  Copyright © 2017年 cuilanqing. All rights reserved.
//  底部离线、修改主题样式（白天、夜间）的view

import UIKit

class BottomView: UIView {
    
    lazy var downloadButton: CLQButton = {
        let tmpBtn: CLQButton = CLQButton(frame: CGRect(x: 15, y: 10, width: 60, height: 30))
        tmpBtn.margin = 4.0
        tmpBtn.setImage(UIImage(named: "Dark_Menu_Download"), for: .normal)
        tmpBtn.setAttributedTitle(NSAttributedString.init(string: "离线", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 12.0), NSForegroundColorAttributeName: Common.SIDEBAR_TEXTCOLOR]), for: .normal)
        tmpBtn.imageSize = CGSize(width: 22, height: 22)
        tmpBtn.contentMode = .center
        tmpBtn.adjustsImageWhenHighlighted = false
        tmpBtn.titlePosition = .Default
        tmpBtn.tag = 10
        tmpBtn.addTarget(self, action: #selector(buttonClickHandler(sender:)), for: .touchUpInside)
        
        
        return tmpBtn
    }()
    
    lazy var changeThemeButton: CLQButton = {
        let tmpBtn: CLQButton = CLQButton(frame: CGRect(x: 15, y: 10, width: 60, height: 30))
        tmpBtn.margin = 4.0
        tmpBtn.setImage(UIImage(named: "Menu_Dark"), for: .normal)
        tmpBtn.setAttributedTitle(NSAttributedString.init(string: "夜间", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 12.0), NSForegroundColorAttributeName: Common.SIDEBAR_TEXTCOLOR]), for: .normal)
        tmpBtn.imageSize = CGSize(width: 22, height: 22)
        tmpBtn.contentMode = .center
        tmpBtn.adjustsImageWhenHighlighted = false
        tmpBtn.titlePosition = .Default
        tmpBtn.tag = 11
        tmpBtn.addTarget(self, action: #selector(buttonClickHandler(sender:)), for: .touchUpInside)
        
        
        return tmpBtn
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(self.downloadButton)
        self.addSubview(self.changeThemeButton)
        
        self.downloadButton.snp.makeConstraints { (make) in
            make.left.equalTo(self.snp.left).offset(15)
            make.centerY.equalTo(self.snp.centerY)
            make.width.equalTo(60)
            make.height.equalTo(30)
        }
        
        self.changeThemeButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.snp.centerY)
            make.right.equalTo(self.snp.right).offset(-45)
            make.width.equalTo(60)
            make.height.equalTo(30)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func buttonClickHandler(sender: UIButton) {
        let alert: UIAlertController!
        switch sender.tag {
        case 10:
            alert = UIAlertController(title: "提示", message: "离线", preferredStyle: .alert)
            break
        case 11:
            alert = UIAlertController(title: "提示", message: "更换主题", preferredStyle: .alert)
            break
        default:
            alert = UIAlertController(title: "提示", message: "", preferredStyle: .alert)
            break
        }
        let action: UIAlertAction!
        action = UIAlertAction(title: "确定", style: .default, handler: nil)
        alert.addAction(action)
        self.window?.rootViewController?.present(alert, animated: true, completion: nil)

    }

}
