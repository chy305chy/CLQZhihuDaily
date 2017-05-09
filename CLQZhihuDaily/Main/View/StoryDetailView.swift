//
//  StoryDetailView.swift
//  CLQZhihuDaily
//
//  Created by 崔岚清 on 2017/5/8.
//  Copyright © 2017年 cuilanqing. All rights reserved.
//  story详情view

import UIKit

class StoryDetailView: UIWebView {
    
    var storyDetailModel: StoryDetailModel? {
        didSet {
            
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
