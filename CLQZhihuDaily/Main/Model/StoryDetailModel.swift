//
//  StoryDetailModel.swift
//  CLQZhihuDaily
//
//  Created by 崔岚清 on 2017/2/17.
//  Copyright © 2017年 cuilanqing. All rights reserved.
//  story详情model

import UIKit

class StoryDetailModel: NSObject {
    var storyId: UInt64!
    var type: NSInteger!
    var css: String!
    var body: String!
    var title: String!
    var image: String!
    var imageSource: String!
    
    init(withDict: NSDictionary) {
        super.init()
        let cssArray = withDict.object(forKey: "css") as! NSArray
        self.css = cssArray.firstObject as! String
        self.type = withDict.object(forKey: "type") as! NSInteger!
        self.storyId = withDict.object(forKey: "id") as! UInt64
        self.body = withDict.object(forKey: "body") as! String
        self.title = withDict.object(forKey: "title") as! String
        self.image = withDict.object(forKey: "image") as! String
        self.imageSource = withDict.object(forKey: "image_source") as! String
    }
    
    class func detailStory(withDict: NSDictionary) -> StoryDetailModel {
        return StoryDetailModel.init(withDict: withDict)
    }
}
