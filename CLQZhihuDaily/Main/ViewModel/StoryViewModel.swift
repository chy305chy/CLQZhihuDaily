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
    let (storySignal, storyObserver) = Signal<AnyObject, NoError>.pipe()
    let (preStorySignal, preStoryObserver) = Signal<AnyObject, NoError>.pipe()
    
    var preDateString: String!
    var hasBindPreStorySignal = false
    var hasBindLatestStorySignal = false
    var hasBindDetailStorySignal = false
    var selectedStoryId: UInt64 = 0
    
    lazy var detailStorySubscriber: Observer<AnyObject, NoError> = {
        let tmpSubscriber = Observer<AnyObject, NoError>(value: { (value) in
            print(value)
        }, failed: nil, completed: {
            self.selectedStoryId = 0
        }, interrupted: nil)
        return tmpSubscriber
    }()
    
    lazy var fetchDetailStoryC: Action<UInt64, AnyObject, NSError> = {
        
        
    }()
    
    func fetchDetailStoryCommand(withId: UInt64) {
//        if !hasBindDetailStorySignal {
//            let detailStorySubscriber = Observer<AnyObject, NoError>(value: { (value) in
//                print(value)
//            }, failed: nil, completed: {
//                self.selectedStoryId = withId
//            }, interrupted: nil)
//            storyDataUtil.detailStorySignal.observe(detailStorySubscriber);
//            hasBindDetailStorySignal = true
//        }
        
        storyDataUtil.detailStorySignal.observe(detailStorySubscriber);
        storyDataUtil.fetchDetailStoryInfo(withId: withId)
    }
    
    /// 获取最新的story
    func fetchLatestStoriesCommand() {
        /* 订阅信号 */
        if !hasBindLatestStorySignal {
            let listStorySubscriber = Observer<AnyObject, NoError>(value: { (value) in
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
                    self.topStoryImageUrls.append(topStoryModel.image)
                    self.topStoryImageTitles.append(topStoryModel.title)
                }
                
                self.datesArray.append(latestDate)
                self.sectionTitlesArray.append("")
                self.listStoryModels.append(listModelsArray)
                self.topStoryModels.append(topModelsArray)
                
                self.storyObserver.send(value: "success" as AnyObject)
                //            self.storyObserver.sendCompleted()
            }, failed: nil, completed: nil, interrupted: nil)
            
            storyDataUtil.latestStorySignal.observe(listStorySubscriber)
            hasBindLatestStorySignal = true
        }
        
        storyDataUtil.fetchLatestStories()
    }
    
    func fetchPreviousStoryCommand() {
        self.preDateString = self.previousDate()
        
        /* 确保下面代码在对象的生命周期中只执行一次 */
        if !hasBindPreStorySignal {
            let previousStorySubscriber = Observer<AnyObject, NoError>(value: { (value) in
                /* 1、先添加日期 */
                self.datesArray.append(self.preDateString)
                self.sectionTitlesArray.append(self.weekDateString(withDate: self.preDateString))
                
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
                
                self.listStoryModels.append(listModelsArray)
                self.preStoryObserver.send(value: true as AnyObject)
            }, failed: nil, completed: nil, interrupted: nil)
            
            storyDataUtil.previousStorySignal.observe(previousStorySubscriber)
            
            self.hasBindPreStorySignal = true
        }
        
        storyDataUtil.fetchStory(beforeDate: preDateString)
    }
    
    /// 获取在self.datesArray数组中最后一个元素之前的日期string
    ///
    /// - Returns: 格式：20170318
    func previousDate() -> String {
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
    func weekDateString(withDate: String) -> String {
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
    
}
