//
//  Common.swift
//  CLQZhihuDaily
//
//  Created by 崔岚清 on 2017/2/10.
//  Copyright © 2017年 cuilanqing. All rights reserved.
//  常用的常量

import UIKit

struct Common {
    // Swift 中， static let 才是真正可靠好用的单例模式
    static let screenWidth = UIScreen.main.bounds.width
    static let screenHeight = UIScreen.main.bounds.height
    static let rootViewController = UIApplication.shared.keyWindow?.rootViewController as! ViewController
    /// 侧边栏的宽度
    static let leftViewWidth: CGFloat = UIScreen.main.bounds.size.width * 0.7
    static let TABLEVIEW_HEADER_VIEW_HEIGHT = 44
    static let TABLEVIEW_ROW_HEIGHT = 90
    
    static let GLOBAL_COLOR_BLUE = UIColor(red: 1.0/255.0, green: 131.0/255.0, blue: 209.0/255.0, alpha: 1.0)
    static let SIDEBAR_BGCOLOR = UIColor(red: 36.0/255.0, green: 42.0/255.0, blue: 50.0/255.0, alpha: 1.0)
    static let SIDEBAR_TEXTCOLOR = UIColor(red: 144.0/255.0, green: 146.0/255.0, blue: 156.0/255.0, alpha: 1.0)
    static let SIDEBAR_SEPLINE_COLOR = UIColor(red: 28/255, green: 34/255, blue: 42/255, alpha: 1.0)
    
    /* API地址 */
    /// 获取story详情信息
    static let API_URL = "http://news-at.zhihu.com/api/4/news/"
    /// 获取最新的story信息
    static let API_URL_NEWS_LATEST = "http://news-at.zhihu.com/api/4/news/latest"
    /// 获取往期的story信息
    static let API_URL_NEWS_BEFORE = "http://news.at.zhihu.com/api/4/news/before/"
    /// 获取启动图片
    static let API_URL_START_IMAGE = "http://news-at.zhihu.com/api/7/prefetch-launch-images/"
    /// 获取某条story的额外信息：评论数量、点赞数等，后接storyId
    static let API_URL_NEWS_EXTRA_INFO = "http://news-at.zhihu.com/api/4/story-extra/"
    
    /* startImageModel归档文件 */
    static let START_IMAGE_FILE_NAME = "startImage.plist"
    static let START_IMAGE_FILE_KEY = "startImageFileKey"
    
    /// 获取最新的stories complete
    static let NOTIFICATION_FETCH_LATEST_STORIES_COMPLETE = "NOTIFICATION_FETCH_LATEST_STORIES_COMPLETE"
    /// 获取往期的stories complete
    static let NOTIFICATION_FETCH_PREVIOUS_STORIES_COMPLETE = "NOTIFICATION_FETCH_PREVIOUS_STORIES_COMPLETE"
    /// 顶部轮播图片选中cell的index
    static let NOTIFICATION_TOP_CYCLEIMAGE_SELECTION_INDEX = "NOTIFICATION_TOP_CYCLEIMAGE_SELECTION_INDEX"
}
