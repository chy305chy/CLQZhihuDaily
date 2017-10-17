//
//  ListStoryTitleTextView.swift
//  CLQZhihuDaily
//
//  Created by 崔岚清 on 2017/5/8.
//  Copyright © 2017年 cuilanqing. All rights reserved.
//

import UIKit

class ListStoryTitleTextView: UITextView {
    weak var storyCell: UITableViewCell!

    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        self.font = UIFont.boldSystemFont(ofSize: 16.0)
        self.textColor = UIColor.black
        self.textAlignment = .left
        self.isEditable = false
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        // 拦截textView上的点击事件，将事件直接传递给上层的cell，解决cell中添加textView时，cell不响应点击的问题
        return storyCell
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
