//
//  StartImageUtil.swift
//  CLQZhihuDaily
//
//  Created by 崔岚清 on 2017/2/14.
//  Copyright © 2017年 cuilanqing. All rights reserved.
//  StartImage工具类

import UIKit
import Alamofire
import ReactiveSwift
import Result

class StartImageDataUtil: NSObject {
    
    let (imgSignal, imgObserver) = Signal<AnyObject, NoError>.pipe()
    
    /// 获取启动页的image的Url地址
    func fetchStartImageUrl() -> SignalProducer<Dictionary<String, String>, NSError> {
        return SignalProducer<Dictionary<String, String>, NSError>({ (observer, _) in
            let url = String(format: "%@%@", Common.API_URL_START_IMAGE, "1242*1920")//"1080*1776")//"1242*1920")
            Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON(completionHandler: { (response) in
                switch(response.result) {
                case .success:
                    let dict = response.result.value as! NSDictionary
                    let array = dict.object(forKey: "creatives") as! NSArray
                    let dict2 = array.object(at: 0) as! NSDictionary
                    // startImage url
                    let imgUrl = dict2.object(forKey: "url") as! String
                    // startImage author
                    let author = (dict2.object(forKey: "text") != nil) ? dict2.object(forKey: "text") as! String : ""
                    
                    let tmpDict: Dictionary<String, String> = ["imgUrl": imgUrl, "author": author]
                    
                    observer.send(value: tmpDict)
                    observer.sendCompleted()
                    break
                case .failure(let error):
                    print("获取startImage URL失败！")
                    observer.send(error: error as NSError)
                    break
                }
            })
        })
    }
    
    /// 获取startImage
    func fetchStartImage(withUrl: String) -> SignalProducer<AnyObject, NSError> {
        return SignalProducer<AnyObject, NSError>({ (observer, _) in
            Alamofire.request(withUrl, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseData { (response) in
                switch(response.result) {
                case .success:
                    observer.send(value: response.result.value as AnyObject)
                    observer.sendCompleted()
                    break
                case .failure(let error):
                    print("获取startImage失败！")
                    observer.send(error: error as NSError)
                    break
                }
            }
        })
    }
    
    /// 保存startImageModel（归档）
    func save(startImageModel: StartImageModel) {
        /* 1、获取文件的路径 */
        let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
        let filePath = documentPath?.appending("/").appending(Common.START_IMAGE_FILE_NAME)
        
        /* 2、将类编码成二进制数据 */
        let tempData = NSMutableData()
        let archiever = NSKeyedArchiver(forWritingWith: tempData)
        archiever.encode(startImageModel, forKey: Common.START_IMAGE_FILE_KEY)
        archiever.finishEncoding()
        
        /* 3、保存编码后的数据 */
        if !tempData.write(toFile: filePath!, atomically: true) {
            print("保存startImageModel失败")
        }
    }
    
    /// 从归档文件中获取startImageModel
    ///
    /// - Returns:  StartImageModel对象
    func getStartImageModel() -> StartImageModel? {
        let model: StartImageModel?
        
        /* 1、获取文件的路径 */
        let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
        let filePath = documentPath?.appending("/").appending(Common.START_IMAGE_FILE_NAME)
        
        /* 2、从文件中读取二进制数据 */
        let tempData = NSData(contentsOfFile: filePath!)
        
        /* 3、通过解码恢复对象 */
        if tempData != nil {
            let unarchiever = NSKeyedUnarchiver(forReadingWith: tempData! as Data)
            model = unarchiever.decodeObject(forKey: Common.START_IMAGE_FILE_KEY) as? StartImageModel
            unarchiever.finishDecoding()
            return model
        }
        return nil;
    }
}
