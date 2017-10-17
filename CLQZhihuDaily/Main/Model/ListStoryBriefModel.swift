//
//  ListStoryBriefModel.swift
//  CLQZhihuDaily
//
//  Created by 崔岚清 on 2017/2/17.
//  Copyright © 2017年 cuilanqing. All rights reserved.
//  列表story简要信息model

import UIKit

class ListStoryBriefModel: StoryBriefModel {
    var images: NSArray!
    var multipic: Bool?
    // 是否已读，已经读过的story更改文字颜色为灰色
    var readed: Bool?
    
    init(withDict: NSDictionary) {
        super.init()
        self.title = withDict.object(forKey: "title") as! String
        self.ga_prefix = withDict.object(forKey: "ga_prefix") as! String
        self.storyId = withDict.object(forKey: "id") as! UInt64
        self.storyType = withDict.object(forKey: "type") as! UInt64
        self.images = withDict.object(forKey: "images") as! NSArray
        self.multipic = withDict.object(forKey: "multipic") as? Bool
        self.readed = false
    }
}
