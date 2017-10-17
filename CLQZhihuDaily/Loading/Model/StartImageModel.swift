//
//  StartImageModel.swift
//  CLQZhihuDaily
//
//  Created by 崔岚清 on 2017/2/16.
//  Copyright © 2017年 cuilanqing. All rights reserved.
//  App启动时的startImage的模型

import UIKit

class StartImageModel: NSObject, NSCoding {
    var startImageUrl: String!
    var startImage: UIImage!
    var startImageAuthor: String!
    
    override init() {
        startImageUrl = ""
        startImage = UIImage()
        startImageAuthor = ""
    }
    
    /* NSCoding协议方法 */
    required init(coder aDecoder: NSCoder) {
        super.init()
        self.startImageUrl = aDecoder.decodeObject(forKey: "startImageUrl") as! String
        self.startImage = aDecoder.decodeObject(forKey: "startImage") as! UIImage
        self.startImageAuthor = aDecoder.decodeObject(forKey: "startImageAuthor") as! String
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.startImageUrl, forKey: "startImageUrl")
        aCoder.encode(self.startImage, forKey: "startImage")
        aCoder.encode(self.startImageAuthor, forKey: "startImageAuthor")
    }
}
