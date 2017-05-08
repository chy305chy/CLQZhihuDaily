//
//  StoryDataUtil.swift
//  CLQZhihuDaily
//
//  Created by 崔岚清 on 2017/2/17.
//  Copyright © 2017年 cuilanqing. All rights reserved.
//  story数据操作工具类

import UIKit
import ReactiveSwift
import Result
import Alamofire

class StoryDataUtil: NSObject {
    // 最新story，通过管道创建热信号
    let (latestStorySignal, latestStoryObserver) = Signal<AnyObject, NoError>.pipe()
    // 之前的story
    let (previousStorySignal, previousStoryObserver) = Signal<AnyObject, NoError>.pipe()
    // story详情
    let (detailStorySignal, detailStoryObserver) = Signal<AnyObject, NoError>.pipe()
    
    /// 获取最新story
    func fetchLatestStories() {
        Alamofire.request(Common.API_URL_NEWS_LATEST, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            switch(response.result) {
            case .success:
                self.latestStoryObserver.send(value: response.result.value as AnyObject)
                break
            case .failure(_):
                print("获取最新story失败！")
                break
            }
        }
    }
    
    /// 获取指定日期之前的story
    ///
    /// - Parameter beforeDate: 指定的日期，格式：20170217
    func fetchStory(beforeDate: String) {
        let url = Common.API_URL_NEWS_BEFORE.appending(beforeDate)
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            switch(response.result) {
            case .success:
                self.previousStoryObserver.send(value: response.result.value as AnyObject)
                break
            case .failure(_):
                print("获取往期story数据失败！")
                break
            }
        }
    }
    
    /// 获取story详情数据
    ///
    /// - Parameter withId: storyId
    func fetchDetailStoryInfo(withId: UInt64) {
        let url = String(format: "%@%lu", Common.API_URL, withId)
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            switch(response.result) {
            case .success:
                self.detailStoryObserver.send(value: response.result.value as AnyObject)
                self.detailStoryObserver.sendCompleted()
                break
            case .failure(let error):
                print("获取story详情数据失败！")
                self.detailStoryObserver.send(error: error as! NoError)
                break
            }
        }
        
    }
    
}
