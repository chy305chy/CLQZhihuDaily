//
//  StoryViewModel.swift
//  CLQZhihuDaily
//
//  Created by 崔岚清 on 2017/2/17.
//  Copyright © 2017年 cuilanqing. All rights reserved.
//

import UIKit
import ReactiveSwift
import Result

class StoryViewModel: NSObject {
    
    lazy var listStoryModels = Array<Array<ListStoryBriefModel>>()
    lazy var topStoryModels = Array<Array<TopStoryBriefModel>>()
    lazy var topStoryImageUrls = Array<String>()
    lazy var topStoryImageTitles = Array<String>()
    lazy var datesArray = Array<String>()
    lazy var sectionTitlesArray = Array<String>()
    
    let storyDataUtil = StoryDataUtil()
    
    dynamic var storyDetailModel: StoryDetailModel?
    dynamic var detailStoryTitleImage: UIImage?
    var preDateString: String!
    // 选中cell的indexPath
    var selectedIndexPath: IndexPath!
    var hasBindPreStorySignal = false
    var hasBindLatestStorySignal = false
    var selectedStoryId: UInt64 = 0
    
    /// 获取story详情
    private lazy var detailStorySubscriber: Observer<AnyObject, ActionError<NSError>> = {
        return Observer<AnyObject, ActionError<NSError>>(value: {[weak self] (value) in
            guard let strongSelf = self else { return }
            let dict: NSDictionary = value as! NSDictionary
            strongSelf.storyDetailModel = StoryDetailModel.detailStory(withDict: dict)
        }, failed: nil, completed: {
            
        }, interrupted: nil)
    }()
    
    private lazy var fetchDetailStoryCommand: Action<UInt64, AnyObject, NSError> = {
        return Action<UInt64, AnyObject, NSError> {[unowned self] (input: UInt64) in
            return self.storyDataUtil.fetchDetailStoryInfo(withId: input)
        }
    }()
    
    func fetchDetailStory(withId: UInt64) {
        self.fetchDetailStoryCommand.apply(withId).start(self.detailStorySubscriber)
    }
    
    /// 获取最新的story
    private lazy var latestStoriesSubscriber: Observer<AnyObject, ActionError<NSError>> = {
        return Observer<AnyObject, ActionError<NSError>>(value: {[weak self] (value) in
            guard let strongSelf = self else { return }
            let dict = value as! NSDictionary
            let storiesArray = dict.object(forKey: "stories") as! NSArray
            let topStoriesArray = dict.object(forKey: "top_stories") as! NSArray
            let latestDate = dict.object(forKey: "date") as! String
            /* 临时变量 */
            var listModelsArray = Array<ListStoryBriefModel>()
            var topModelsArray = Array<TopStoryBriefModel>()
            
            for storyDict in storiesArray {
                let tmpDict = storyDict as! NSDictionary
                let listStoryModel = ListStoryBriefModel(withDict: tmpDict)
                listModelsArray.append(listStoryModel)
            }
            
            for topStoryDict in topStoriesArray {
                let tmpDict = topStoryDict as! NSDictionary
                let topStoryModel = TopStoryBriefModel(withDict: tmpDict)
                topModelsArray.append(topStoryModel)
            }
            
            if strongSelf.listStoryModels.count != 0 {
                // 下拉加载最新(非第一次加载)
                // 增量添加
                let topStoryDelta = topModelsArray.count - strongSelf.topStoryModels[0].count
                let listStoryDelta = listModelsArray.count - strongSelf.listStoryModels[0].count
                
                for i in (0 ..< topStoryDelta).reversed() {
                    strongSelf.topStoryImageUrls.insert(topModelsArray[i].image, at: 0)
                    strongSelf.topStoryImageTitles.insert(topModelsArray[i].title, at: 0)
                    strongSelf.topStoryModels[0].insert(topModelsArray[i], at: 0)
                }
                
                for i in (0 ..< listStoryDelta).reversed() {
                    strongSelf.listStoryModels[0].insert(listModelsArray[i], at: 0)
                }
            }else {
                for topStoryDict in topStoriesArray {
                    let tmpDict = topStoryDict as! NSDictionary
                    let topStoryModel = TopStoryBriefModel(withDict: tmpDict)
                    strongSelf.topStoryImageUrls.append(topStoryModel.image)
                    strongSelf.topStoryImageTitles.append(topStoryModel.title)
                }
                strongSelf.datesArray.append(latestDate)
                strongSelf.sectionTitlesArray.append("")
                strongSelf.listStoryModels.append(listModelsArray)
                strongSelf.topStoryModels.append(topModelsArray)
            }
            
            NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: Common.NOTIFICATION_FETCH_LATEST_STORIES_COMPLETE)))
        })
    }()
    
    private lazy var fetchLatestStoriesCommand: Action<AnyObject, AnyObject, NSError> = {
        return Action<AnyObject, AnyObject, NSError>{[unowned self](input: AnyObject) in
            return self.storyDataUtil.fetchLatestStories();
        }
    }()
    
    func fetchLatestStories() {
        self.fetchLatestStoriesCommand.apply(NSNull()).start(self.latestStoriesSubscriber)
    }
    
    /// 获取往期的story
    private lazy var previousStorySubscriber: Observer<AnyObject, ActionError<NSError>> = {
        return Observer<AnyObject, ActionError<NSError>>( value: {[weak self] (value) in
            guard let strongSelf = self else { return }
            /* 1、先添加日期 */
            strongSelf.datesArray.append(strongSelf.preDateString)
            strongSelf.sectionTitlesArray.append(strongSelf.weekDateString(withDate: strongSelf.preDateString))
            
            /* 2、解析数据 */
            let dict = value as! NSDictionary
            let storiesArray = dict.object(forKey: "stories") as! NSArray
            
            /* 临时变量 */
            var listModelsArray = Array<ListStoryBriefModel>()
            for storyDict in storiesArray {
                let tmpDict = storyDict as! NSDictionary
                let listStoryModel = ListStoryBriefModel(withDict: tmpDict)
                listModelsArray.append(listStoryModel)
            }
            
            strongSelf.listStoryModels.append(listModelsArray)
            
            NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: Common.NOTIFICATION_FETCH_PREVIOUS_STORIES_COMPLETE)))

            }, failed: nil, completed: {
                
        }, interrupted: nil)
    }()
    
    private lazy var fetchPreviousStoryCommand: Action<String, AnyObject, NSError> = {
        return Action<String, AnyObject, NSError> {[unowned self] (input: String) in
            return self.storyDataUtil.fetchStories(beforeDate: input)
        }
    }()
    
    func fetchPreviousStories() {
        self.preDateString = self.previousDate()
        self.fetchPreviousStoryCommand.apply(self.preDateString).start(self.previousStorySubscriber)
    }
    
    /// 获取在self.datesArray数组中最后一个元素之前的日期string
    ///
    /// - Returns: 格式：20170318
    private func previousDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYYMMdd"
        let latestDate = dateFormatter.date(from: self.datesArray.last!)
        let previousDate = Date(timeInterval: -3600*24, since: latestDate!)
        let previousDateString = dateFormatter.string(from: previousDate)

        return previousDateString
    }
    
    /// 根据传入的日期返回带有星期信息的日期字符串
    ///
    /// - Parameter withDate: 20170309
    /// - Returns: 03月09日星期X
    private func weekDateString(withDate: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYYMMdd"
        dateFormatter.locale = Locale(identifier: "zh_Hans_CN")
        dateFormatter.timeZone = TimeZone(secondsFromGMT: -8*3600)  /* 北京时区为东8区 */
        let date = dateFormatter.date(from: withDate)
        let components = CalendarSingleton.sharedGregorianCalendar!.components([.year, .month, .day, .weekday], from: date!)
        let weekDay = components.weekday
        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateFormat = "MM月dd日"
        let dateString = dateFormatter2.string(from: date!)
        var weekDateString: String!
        
        switch weekDay! {
        case 1:
            weekDateString = String(format: "%@%@", dateString, "星期日")
            break
        case 2:
            weekDateString = String(format: "%@%@", dateString, "星期一")
            break
        case 3:
            weekDateString = String(format: "%@%@", dateString, "星期二")
            break
        case 4:
            weekDateString = String(format: "%@%@", dateString, "星期三")
            break
        case 5:
            weekDateString = String(format: "%@%@", dateString, "星期四")
            break
        case 6:
            weekDateString = String(format: "%@%@", dateString, "星期五")
            break
        case 7:
            weekDateString = String(format: "%@%@", dateString, "星期六")
            break
        default:
            break
        }
        
        return weekDateString
    }
    
    // 获取story详情页顶部的titleImage
    private lazy var detailStoryTitleImageSubscriber: Observer<UIImage, ActionError<NSError>> = {
        return Observer<UIImage, ActionError<NSError>>(value: { [weak self] (value) in
            guard let strongSelf = self else { return }
            strongSelf.detailStoryTitleImage = value
        }, failed: nil, completed: nil, interrupted: nil)
    }()
    
    private lazy var detailStoryTitleImageCommand: Action<String, UIImage, NSError> = {
        return Action<String, UIImage, NSError> { (input: String) in
            return self.storyDataUtil.fetchDetailStoryTitleImage(withUrl: input)
        }
    }()
    
    func fetchStoryDetailTitleImage(withUrl: String) {
        self.detailStoryTitleImageCommand.apply(withUrl).start(self.detailStoryTitleImageSubscriber)
    }
}
