//
//  SettingFavoriteMsgView.swift
//  CLQZhihuDaily
//
//  Created by 崔岚清 on 2017/5/15.
//  Copyright © 2017年 cuilanqing. All rights reserved.
//  收藏、消息、设置view

import UIKit

class SettingFavoriteMsgView: UIView {
    
    lazy var favoriteButton: CLQButton = {
        let tmpBtn: CLQButton = CLQButton(frame: CGRect.init(x: 0, y: 0, width: self.frame.size.width/3, height: 47))
        tmpBtn.setImage(UIImage(named: "Dark_Menu_Icon_Collect"), for: .normal)
        tmpBtn.setAttributedTitle(NSAttributedString.init(string: "收藏", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 12.0), NSForegroundColorAttributeName: Common.SIDEBAR_TEXTCOLOR]), for: .normal)
        tmpBtn.imageSize = CGSize(width: 20, height: 20)
        tmpBtn.contentMode = .center
        tmpBtn.adjustsImageWhenHighlighted = false
        tmpBtn.titlePosition = .Bottom
        tmpBtn.tag = 10
        tmpBtn.addTarget(self, action: #selector(buttonClickHandler(sender:)), for: .touchUpInside)
        
        return tmpBtn
    }()
    
    lazy var messageButton: CLQButton = {
        let tmpBtn: CLQButton = CLQButton(frame: CGRect.init(x: self.frame.size.width/3, y: 0, width: self.frame.size.width/3, height: 47))
        tmpBtn.setImage(UIImage(named: "Dark_Menu_Icon_Message"), for: .normal)
        tmpBtn.setAttributedTitle(NSAttributedString.init(string: "消息", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 12.0), NSForegroundColorAttributeName: Common.SIDEBAR_TEXTCOLOR]), for: .normal)
        tmpBtn.imageSize = CGSize(width: 20, height: 20)
        tmpBtn.contentMode = .center
        tmpBtn.adjustsImageWhenHighlighted = false
        tmpBtn.titlePosition = .Bottom
        tmpBtn.tag = 11
        tmpBtn.addTarget(self, action: #selector(buttonClickHandler(sender:)), for: .touchUpInside)
        
        return tmpBtn
    }()
    
    lazy var settingButton: CLQButton = {
        let tmpBtn: CLQButton = CLQButton(frame: CGRect.init(x: 2*self.frame.size.width/3, y: 0, width: self.frame.size.width/3, height: 47))
        tmpBtn.setImage(UIImage(named: "Dark_Menu_Icon_Setting"), for: .normal)
        tmpBtn.setAttributedTitle(NSAttributedString.init(string: "设置", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 12.0), NSForegroundColorAttributeName: Common.SIDEBAR_TEXTCOLOR]), for: .normal)
        tmpBtn.imageSize = CGSize(width: 20, height: 20)
        tmpBtn.contentMode = .center
        tmpBtn.adjustsImageWhenHighlighted = false
        tmpBtn.titlePosition = .Bottom
        tmpBtn.tag = 12
        tmpBtn.addTarget(self, action: #selector(buttonClickHandler(sender:)), for: .touchUpInside)
        
        return tmpBtn
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.favoriteButton)
        self.addSubview(self.messageButton)
        self.addSubview(self.settingButton)
        
        let sepLine: UIView = UIView(frame: CGRect(x: 0, y: 50, width: self.frame.size.width, height: 0.5))
        sepLine.backgroundColor = Common.SIDEBAR_SEPLINE_COLOR
        self.addSubview(sepLine)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func buttonClickHandler(sender: UIButton) {
        let alert: UIAlertController!
        switch sender.tag {
        case 10:
            alert = UIAlertController(title: "提示", message: "收藏", preferredStyle: .alert)
            break
        case 11:
            alert = UIAlertController(title: "提示", message: "消息", preferredStyle: .alert)
            break
        case 12:
            alert = UIAlertController(title: "提示", message: "设置", preferredStyle: .alert)
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
