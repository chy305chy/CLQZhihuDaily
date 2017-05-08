//
//  AuxiliaryModels.swift
//  CyclePictureView
//
//  Created by wl on 15/11/8.
//  Copyright © 2015年 wl. All rights reserved.
//

/***************************************************
 *  如果您发现任何BUG,或者有更好的建议或者意见，欢迎您的指出。
 *邮箱:wxl19950606@163.com.感谢您的支持
 ***************************************************/

import UIKit

//========================================================
// MARK: - 图片类型处理
//========================================================
enum ImageSource {
    case local(name: String)
    case network(urlStr: String)
}

enum ImageType {
    case local
    case network
}

struct ImageBox {
    var imageType: ImageType
    var imageArray: [ImageSource]
    
    init(imageType: ImageType, imageArray: [String]) {
        
        self.imageType = imageType
        self.imageArray = []
        
        switch imageType {
        case .local:
            for str in imageArray {
                self.imageArray.append(ImageSource.local(name: str))
            }
        case .network:
            for str in imageArray {
                self.imageArray.append(ImageSource.network(urlStr: str))
            }
        }
    }
    
    subscript (index: Int) -> ImageSource {
        get {
            return self.imageArray[index]
        }
    }
}

//========================================================
// MARK: - PageControl对齐协议
//========================================================

enum PageControlAliment {
    case centerBottom
    case leftBottom
    case rightBottom
}

protocol PageControlAlimentProtocol: class{
    var pageControlAliment: PageControlAliment {get set}
    func AdjustPageControlPlace(_ pageControl: UIPageControl)
}

extension PageControlAlimentProtocol where Self : UIView {
    func AdjustPageControlPlace(_ pageControl: UIPageControl) {

        if !pageControl.isHidden {
            switch self.pageControlAliment {
            case .centerBottom:
                let pageW:CGFloat = CGFloat(pageControl.numberOfPages * 15)
                let pageH:CGFloat = 20
                let pageX = self.center.x - 0.5 * pageW
                let pageY = self.bounds.height -  pageH
                pageControl.frame = CGRect(x: pageX, y: pageY, width: pageW, height: pageH)
            case .leftBottom:
                let pageW:CGFloat = CGFloat(pageControl.numberOfPages * 15)
                let pageH:CGFloat = 20
                let pageX = self.bounds.origin.x
                let pageY = self.bounds.height -  pageH
                pageControl.frame = CGRect(x: pageX, y: pageY, width: pageW, height: pageH)
            case .rightBottom:
                let pageW:CGFloat = CGFloat(pageControl.numberOfPages * 15)
                let pageH:CGFloat = 20
                let pageX = self.bounds.width - pageW
                let pageY = self.bounds.height -  pageH
                pageControl.frame = CGRect(x: pageX, y: pageY, width: pageW, height: pageH)

            }
        }
    }
}

//========================================================
// MARK: - 无限滚动协议
//========================================================
protocol EndlessCycleProtocol: class{
    /// 是否开启自动滚动
    var autoScroll: Bool {get set}
    /// 开启自动滚动后，自动翻页的时间
    var timeInterval: Double {get set}
    /// 用于控制自动滚动的定时器
    var timer: Timer? {get set}
    /// 是否开启无限滚动模式
    var needEndlessScroll: Bool {get set}
    /// 开启无限滚动模式后，cell需要增加的倍数
    var imageTimes: Int {get}
    /// 开启无限滚动模式后,真实的cell数量
    var actualItemCount: Int {get set}
    
    /**
    设置定时器,用于控制自动翻页
    */
    func setupTimer(_ userInfo: AnyObject?)

    /**
    在无限滚动模式中，显示的第一页其实是最中间的那一个cell
    */
    func showFirstImagePageInCollectionView(_ collectionView: UICollectionView)
}

extension EndlessCycleProtocol where Self : UIView  {
    
    func autoChangePicture(_ collectionView: UICollectionView) {
        
        guard actualItemCount != 0 else {
            return
        }
        
        let flowLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let currentIndex = Int(collectionView.contentOffset.x / flowLayout.itemSize.width)
        
        let nextIndex = currentIndex + 1
        if nextIndex >= actualItemCount {
            showFirstImagePageInCollectionView(collectionView)
        }else {
            
            collectionView.scrollToItem(at: IndexPath(item: nextIndex, section: 0), at: UICollectionViewScrollPosition(), animated: true)
        }
        
    }
    
    func showFirstImagePageInCollectionView(_ collectionView: UICollectionView) {
        guard actualItemCount != 0 else {
            return
        }
        var newIndex = 0
        if needEndlessScroll {
            newIndex = actualItemCount / 2
        }
        collectionView.scrollToItem(at: IndexPath(item: newIndex, section: 0), at: UICollectionViewScrollPosition(), animated: false)
    }
}
