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
    var startImageAuthor: String!
    
    let startImageUtil = StartImageDataUtil()
    let startImageModel = StartImageModel()
    
//    let (signal, observer) = Signal<AnyObject, NoError>.pipe()
    
    /// 获取startImage
    func fetchStartImage(withUrl: String, author: String) {
        let imgSubscriber = Observer<AnyObject, NoError>(value: { (value) in
            // startimage
            let imgData = value as! Data
            let image = UIImage(data: imgData)
            // author
            self.startImageAuthor = author
            self.startImage = image!
            
            // 设置startimage model
            self.startImageModel.startImageUrl = withUrl
            self.startImageModel.startImage = image!
            self.startImageModel.startImageAuthor = self.startImageAuthor
            
            // Model归档
            self.startImageUtil.save(startImageModel: self.startImageModel)
            
//            self.observer.send(value: image!)
//            self.observer.sendCompleted()
        }, failed: nil, completed: nil, interrupted: nil)
        
        startImageUtil.imgSignal.observe(imgSubscriber)
        // 调用工具类方法获取startImage
        startImageUtil.fetchStartImage(withUrl: withUrl, author: author)
    }
    
    /// 从本地归档文件中获取
    func fetchStartImageFromLocal() -> Void {
        let startImageModel = startImageUtil.getStartImageModel()
        
        self.startImageAuthor = startImageModel?.startImageAuthor
        self.startImage = startImageModel!.startImage
    }
}
