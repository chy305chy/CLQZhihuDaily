//
//  StoryDetailExtraModel.swift
//  CLQZhihuDaily
//
//  Created by 崔岚清 on 2017/6/1.
//  Copyright © 2017年 cuilanqing. All rights reserved.
//  story的额外信息Model

import UIKit

class StoryDetailExtraModel: NSObject {
    
    var long_comments: NSInteger!
    var popularity: NSInteger!
    var short_comments: NSInteger!
    var comments: NSInteger!
    
    init(withDict: NSDictionary) {
        super.init()
        
        self.long_comments = withDict.object(forKey: "long_comments") as! NSInteger
        self.popularity = withDict.object(forKey: "popularity") as! NSInteger
        self.short_comments = withDict.object(forKey: "short_comments") as! NSInteger
        self.comments = withDict.object(forKey: "comments") as! NSInteger
    }

}
