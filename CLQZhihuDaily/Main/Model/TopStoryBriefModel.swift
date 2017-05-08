//
//  TopStoryBriefModel.swift
//  CLQZhihuDaily
//
//  Created by 崔岚清 on 2017/2/17.
//  Copyright © 2017年 cuilanqing. All rights reserved.
//  顶部story简要信息

import UIKit

class TopStoryBriefModel: StoryBriefModel {
    var image: String!
    
    init(withDict: NSDictionary) {
        super.init()
        self.title = withDict.object(forKey: "title") as! String
        self.ga_prefix = withDict.object(forKey: "ga_prefix") as! String
        self.storyType = withDict.object(forKey: "type") as! UInt64
        self.storyId = withDict.object(forKey: "id") as! UInt64
        self.image = withDict.object(forKey: "image") as! String
    }
}
