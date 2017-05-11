//
//  LoadingViewModel.swift
//  CLQZhihuDaily
//
//  Created by 崔岚清 on 2017/2/15.
//  Copyright © 2017年 cuilanqing. All rights reserved.
//

import UIKit
import ReactiveCocoa
import ReactiveSwift
import Result

class LoadingViewModel: NSObject {
    // swift 单例
    static let sharedLoadingViewModel = LoadingViewModel()
    private override init() {}
    
    dynamic var startImage: UIImage!
    var startImageAuthor: String?
    dynamic var startImageUrl: String?
    
    let startImageUtil = StartImageDataUtil()
    let startImageModel = StartImageModel()
    
    /// 获取startImage的url
    private lazy var startImageUrlSubscriber: Observer<Dictionary<String, String>, ActionError<NSError>> = {
        return Observer<Dictionary<String, String>, ActionError<NSError>>(value: {[weak self] (value) in
            guard let strongSelf = self else { return }
            let dict: Dictionary<String, String> = value
            
            strongSelf.startImageAuthor = dict["author"]
            strongSelf.startImageUrl = dict["imgUrl"]
        }, failed: nil, completed: nil, interrupted: nil)
    }()
    
    private lazy var startImageUrlCommand: Action<Any, Dictionary<String, String>, NSError> = {
        return Action<Any, Dictionary<String, String>, NSError> {[unowned self] (input: Any) in
            return self.startImageUtil.fetchStartImageUrl()
        }
    }()
    
    func fetchStartImageUrl() {
        self.startImageUrlCommand.apply(NSNull()).start(self.startImageUrlSubscriber)
    }
    
    /// 获取startImage
    private lazy var startImageSubscriber: Observer<AnyObject, ActionError<NSError>> = {
        return Observer<AnyObject, ActionError<NSError>>(value: {[weak self] (value) in
            guard let strongSelf = self else { return }
            // startimage
            let imgData = value as! Data
            let image = UIImage(data: imgData)
            // author
            strongSelf.startImage = image!
            
            // 设置startimage model
            strongSelf.startImageModel.startImageUrl = strongSelf.startImageUrl
            strongSelf.startImageModel.startImage = image!
            strongSelf.startImageModel.startImageAuthor = strongSelf.startImageAuthor
            
            // Model归档
            strongSelf.startImageUtil.save(startImageModel: strongSelf.startImageModel)
        }, failed: nil, completed: nil, interrupted: nil)
    }()
    
    private lazy var startImageCommand: Action<Any, AnyObject, NSError> = {
        return Action<Any, AnyObject, NSError> {[unowned self] (input: Any) in
            return self.startImageUtil.fetchStartImage(withUrl: self.startImageUrl!)
        }
    }()
    
    func fetchStartImage() {
        self.startImageCommand.apply(NSNull()).start(self.startImageSubscriber)
    }
    
    /// 从本地归档文件中获取
    func fetchStartImageFromLocal() -> Void {
        let startImageModel = startImageUtil.getStartImageModel()
        
        self.startImageAuthor = startImageModel?.startImageAuthor
        self.startImage = startImageModel!.startImage
    }
}
