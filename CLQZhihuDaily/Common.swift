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
    static let leftViewWidth: CGFloat = 200.0
    static let TABLEVIEW_HEADER_VIEW_HEIGHT = 44
    static let TABLEVIEW_ROW_HEIGHT = 90
    
    static let GLOBAL_COLOR_BLUE = UIColor(red: 1/255.0, green: 131/255.0, blue: 209/255.0, alpha: 1)
    
    /* API地址 */
    static let API_URL = "http://news-at.zhihu.com/api/4/news/"
    static let API_URL_NEWS_LATEST = "http://news-at.zhihu.com/api/4/news/latest"
    static let API_URL_NEWS_BEFORE = "http://news.at.zhihu.com/api/4/news/before/"
    static let API_URL_START_IMAGE = "http://news-at.zhihu.com/api/7/prefetch-launch-images/"
    
    /* startImageModel归档文件 */
    static let START_IMAGE_FILE_NAME = "startImage.plist"
    static let START_IMAGE_FILE_KEY = "startImageFileKey"
    
    /// 获取最新的stories complete
    static let NOTIFICATION_FETCH_LATEST_STORIES_COMPLETE = "NOTIFICATION_FETCH_LATEST_STORIES_COMPLETE"
    /// 获取往期的stories complete
    static let NOTIFICATION_FETCH_PREVIOUS_STORIES_COMPLETE = "NOTIFICATION_FETCH_PREVIOUS_STORIES_COMPLETE"
}
