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

    /// 获取最新story
    func fetchLatestStories() -> SignalProducer<AnyObject, NSError> {
        return SignalProducer<AnyObject, NSError> { (observer, _) in
            Alamofire.request(Common.API_URL_NEWS_LATEST, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
                switch(response.result) {
                case .success:
                    observer.send(value: response.result.value as AnyObject)
                    observer.sendCompleted()
                    break
                case .failure(let error):
                    print("获取最新story失败！：%@", error)
                    observer.send(error: error as NSError)
                    break
                }
            }
        }
    }
    
    /// 获取指定日期之前的story
    ///
    /// - Parameter beforeDate: 指定的日期，格式：20170217
    func fetchStories(beforeDate: String) -> SignalProducer<AnyObject, NSError> {
        return SignalProducer<AnyObject, NSError>({ (observer, _) in
            let url = Common.API_URL_NEWS_BEFORE.appending(beforeDate)
            Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
                switch(response.result) {
                case .success:
                    observer.send(value: response.result.value as AnyObject)
                    observer.sendCompleted()
                    break
                case .failure(let error):
                    print("获取往期story数据失败！:%@", error)
                    observer.send(error: error as NSError)
                    break
                }
            }

        })
    }
    
    /// 获取story详情数据
    ///
    /// - Parameter withId: storyId
    func fetchDetailStoryInfo(withId: UInt64) -> SignalProducer<AnyObject, NSError> {
        return SignalProducer<AnyObject, NSError> { observer, _ in
            let url = String(format: "%@%lu", Common.API_URL, withId)
            Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
                switch(response.result) {
                case .success:
                    observer.send(value: response.result.value as AnyObject)
                    observer.sendCompleted()
                    break
                case .failure(let error):
                    print("获取story详情数据失败！: %@", error)
                    observer.send(error: error as NSError)
                    break
                }
            }
        }
    }
    
    /// 获取story详情的额外数据：评论数目、点赞数等
    ///
    /// - Parameter withId: storyId
    /// - Returns: SignalProducer
    func fetchDetailStoryExtraInfo(withId: UInt64) -> SignalProducer<AnyObject, NSError> {
        return SignalProducer<AnyObject, NSError>({ (observer, _) in
            let url = String(format: "%@%lu", Common.API_URL_NEWS_EXTRA_INFO, withId)
            Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON(completionHandler: { (response) in
                switch(response.result) {
                case .success:
                    observer.send(value: response.result.value as AnyObject)
                    observer.sendCompleted()
                    break
                case .failure(let error):
                    print("获取story详情评论数据失败！: %@", error)
                    observer.send(error: error as NSError)
                    break
                }
            })
        })
    }
    
    /// 获取story详情页的顶部标题图片
    ///
    /// - Parameter withUrl: 图片url地址
    /// - Returns: SignalProducer
    func fetchDetailStoryTitleImage(withUrl: String) -> SignalProducer<UIImage, NSError> {
        return SignalProducer<UIImage, NSError>({ (observer, _) in
            Alamofire.request(withUrl, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseData(completionHandler: { (response) in
                switch(response.result) {
                case .success:
                    let image: UIImage = UIImage(data: response.result.value!)!
                    observer.send(value: image)
                    observer.sendCompleted()
                    break
                case .failure(let error):
                    print("获取story详情标题图片失败！: %@", error)
                    observer.send(error: error as NSError)
                    break
                }
            })
        })
    }
}
