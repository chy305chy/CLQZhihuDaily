//
//  CLQButton.swift
//  CLQZhihuDaily
//
//  Created by 崔岚清 on 2017/5/15.
//  Copyright © 2017年 cuilanqing. All rights reserved.
//  自定义button，可选button的图片和标题位置

import UIKit

enum CLQButtonTitlePosition {
    case Default    // 系统默认（标题在右）
    case Left       // 标题在左
    case Bottom     // 标题在下
}

class CLQButton: UIButton {

    var imageSize: CGSize!
    var titlePosition: CLQButtonTitlePosition! {
        didSet {
            if self.titlePosition != .Default {
                self.titleLabel?.textAlignment = .center
            }
        }
    }
    var margin: CGFloat!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.margin = 4.0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 重写父类方法,改变标题和image的坐标
    override func imageRect(forContentRect contentRect: CGRect) -> CGRect {
        if self.titlePosition == .Left {
            let x: CGFloat = contentRect.size.width - self.margin - self.imageSize.width
            var y: CGFloat = contentRect.size.height - self.imageSize.height
            y = y / 2
            
            return CGRect(x: x, y: y, width: self.imageSize.width, height: self.imageSize.height)
        }else if self.titlePosition == .Bottom {
            var x: CGFloat = contentRect.size.width - self.imageSize.width
            let y: CGFloat = self.margin
            x = x / 2
            
            return CGRect(x: x, y: y, width: self.imageSize.width, height: self.imageSize.height)
        }else {
            // 默认情况，图片在左，标题在右
            let x: CGFloat = self.margin
            var y: CGFloat = contentRect.size.height - self.imageSize.height
            y = y / 2
            
            return CGRect(x: x, y: y, width: self.imageSize.width, height: self.imageSize.height)
        }
    }
    
    override func titleRect(forContentRect contentRect: CGRect) -> CGRect {
        if self.titlePosition == .Left {
            return CGRect(x: self.margin, y: 0, width: contentRect.size.width - 2 * self.margin - self.imageSize.width, height: contentRect.size.height)
        }else if self.titlePosition == .Bottom {
            return CGRect(x: 0, y: self.margin + self.imageSize.height, width: contentRect.size.width, height: contentRect.size.height - self.margin - self.imageSize.height)
        }else {
            let x: CGFloat = 2 * self.margin + self.imageSize.width
            let y: CGFloat = 0
            return CGRect(x: x, y: y, width: contentRect.size.width - 3*self.margin - self.imageSize.width, height: contentRect.size.height)
        }
    }

}
