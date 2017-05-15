//
//  CyclePictureView.swift
//  CyclePictureView
//
//  Created by wl on 15/11/7.
//  Copyright © 2015年 wl. All rights reserved.
//

/***************************************************
 *  如果您发现任何BUG,或者有更好的建议或者意见，欢迎您的指出。
 *邮箱:wxl19950606@163.com.感谢您的支持
 ***************************************************/

import UIKit

protocol CyclePictureViewDelegate: class{
    func cyclePictureView(_ cyclePictureView: CyclePictureView, didSelectItemAtIndexPath indexPath: IndexPath)
}

class CyclePictureView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, PageControlAlimentProtocol, EndlessCycleProtocol {

// MARK: - 属性接口
//========================================================
// MARK: 数据源
//========================================================
    
    /// 存放本地图片名称的数组
    var localImageArray: [String]? {
        didSet {
            self.imageBox = ImageBox(imageType: .local, imageArray: localImageArray!)
            self.reloadData()
        }

    }
    /// 存放网络图片路径的数组
    var imageURLArray: [String]? {
        didSet {
            self.imageBox = ImageBox(imageType: .network, imageArray: imageURLArray!)
            self.reloadData()
        }
    }
    /// 图片的描述文字
    var imageTitleArray: [String]?
    
//========================================================
// MARK:  自定义样式接口
//========================================================
    var showPageControl: Bool = true {
        didSet {
            self.pageControl?.isHidden = !showPageControl
        }
    }
    var currentDotColor: UIColor = UIColor.orange {
        didSet {
            self.pageControl?.currentPageIndicatorTintColor = currentDotColor
        }
    }
    var otherDotColor: UIColor = UIColor.gray {
        didSet {
            self.pageControl?.pageIndicatorTintColor = otherDotColor
        }
    }
//    var pageControlAlpha: CGFloat = 1.0 {
//        didSet {
//            self.pageControl?.alpha = pageControlAlpha
//        }
//    }
    /// pageControl的位置，默认是剧中在底部(PageControlAlimentProtocol提供)
    var pageControlAliment: PageControlAliment = .centerBottom
    /// 加载网络图片使用的占位图片
    var placeholderImage: UIImage?
    /// 图片的对齐模式
    var pictureContentMode: UIViewContentMode?
    
    // 一些cell文字描述的属性
    var detailLableTextFont: UIFont?
    var detailLableTextColor: UIColor?
    var detailLableBackgroundColor: UIColor?
    var detailLableHeight: CGFloat?
    var detailLableAlpha: CGFloat?
    
//========================================================
// MARK: 滚动控制接口
//========================================================
    
    weak var delegate: CyclePictureViewDelegate?
    /// 是否开启自动滚动,默认是ture,EndlessCycleProtocol提供
    var autoScroll: Bool = true {
        didSet {
            self.timer?.invalidate() //先取消先前定时器
            if autoScroll {
                self.setupTimer(nil)   //重新设置定时器
            }
        }
    }
    /// 开启自动滚动后，自动翻页的时间，默认为2秒,EndlessCycleProtocol提供
    var timeInterval: Double = 3.0 {
        didSet {
            if autoScroll {
                self.setupTimer(nil)   //重新设置定时器
            }
        }
    }
    /// 是否开启无限滚动模式,EndlessCycleProtocol提供
    var needEndlessScroll: Bool  = true {
        didSet {
            self.reloadData()
        }
    }
    
//========================================================
// MARK: - 内部属性
//========================================================
    
    fileprivate var imageBox: ImageBox?
    /// 开启无限滚动模式后,真实的cell数量
    var actualItemCount: Int = 0 // EndlessCycleProtocol提供
    let imageTimes: Int = 150   // EndlessCycleProtocol提供
    /// 控制自动滚动的定时器
    var timer: Timer?     // EndlessCycleProtocol提供
    
    fileprivate var pageControl: UIPageControl?
    fileprivate var collectionView: UICollectionView!
    fileprivate let cellID: String = "CyclePictureCell"
    fileprivate var flowLayout: UICollectionViewFlowLayout?

     // MARK: - 初始化方法
    
    init(frame: CGRect, localImageArray: [String]?) {
        
        super.init(frame: frame)
        self.setupCollectionView()
        
        if let array = localImageArray {
            self.localImageArray = array
            self.imageBox = ImageBox(imageType: .local, imageArray: localImageArray!)
            self.reloadData()
        }
    }
    
    init(frame: CGRect, imageURLArray: [String]?) {
        
        super.init(frame: frame)
        self.setupCollectionView()
        
        if let array = imageURLArray {
            self.imageURLArray = array
            self.imageBox = ImageBox(imageType: .local, imageArray: imageURLArray!)
            self.reloadData()
        }
    }
    
    override func awakeFromNib() {
       
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupCollectionView()
    }
    
    deinit{
        //print("CyclePictureView---deinit")
    }
    
    /**
    设置CollectionView相关内容
    */
    fileprivate func setupCollectionView() {
        
        // 初始化布局
        let flowLayout =  UICollectionViewFlowLayout()

//        flowLayout.itemSize = self.frame.size
        flowLayout.minimumLineSpacing = 0
        flowLayout.scrollDirection = .horizontal
        self.flowLayout = flowLayout
        
        let collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: flowLayout)
//        collectionView.backgroundColor = UIColor.orangeColor()
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.bounces = false
        collectionView.isPagingEnabled = true
        // TODO: view充当数据源和代理，感觉不符合逻辑，待修改
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(CyclePictureCell.self, forCellWithReuseIdentifier: cellID)
        self.addSubview(collectionView)

        self.collectionView = collectionView
    }
    /**
    设置PageControl
    */
    fileprivate func setupPageControl() {
        
        self.pageControl?.removeFromSuperview()
        
        guard self.imageBox!.imageArray.count > 1 else {
            return
        }
        
        if self.showPageControl {
            let pageControl = UIPageControl()
            pageControl.numberOfPages = self.imageBox!.imageArray.count
            pageControl.currentPageIndicatorTintColor = self.currentDotColor
            pageControl.pageIndicatorTintColor = self.otherDotColor
            pageControl.isUserInteractionEnabled = false
            self.addSubview(pageControl)
            
            self.pageControl = pageControl
        }

    }
    
// MARK: - 内部方法
    
    /**
    解决定时器强引用视图，导致视图不被释放
    */
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        guard let _ = newSuperview else {
            self.timer?.invalidate()
            self.timer = nil
            return
        }
    }
    /**
    重新加载数据，每当localImageArray或者imageURLArray
    被设置的时候调用
    */
    fileprivate func reloadData() {
        
        guard let imageBox = self.imageBox else {
            //print("reloadData---error")
            return
        }
        
        if imageBox.imageArray.count > 1 {
            self.actualItemCount =  self.needEndlessScroll ? imageBox.imageArray.count * imageTimes : imageBox.imageArray.count
        }else {
            self.actualItemCount = 1
        }
        
        //重新加载数据
        self.collectionView.reloadData()
        self.setupPageControl()
        if self.autoScroll {
            self.setupTimer(nil)
        }
        
        self.showFirstImagePageInCollectionView(self.collectionView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.flowLayout?.itemSize = self.frame.size
        self.collectionView.frame = self.bounds
        //解决从SB中加载时，contentInset.Top默认为64的问题
        self.collectionView.contentInset = UIEdgeInsets.zero
        
        guard let pageControl = self.pageControl else {
            return
        }
        //PageControlAlimentProtocol协议方法，用于调整对齐
        self.AdjustPageControlPlace(pageControl)
    }
    /**
    设置定时器,EndlessCycleProtocol提供
    */
    func setupTimer(_ userInfo: AnyObject?) {
        self.timer?.invalidate() //先取消先前定时器
//        let timer = Timer(timeInterval: timeInterval, target: self, selector: #selector("changePicture"), userInfo: userInfo, repeats: true)
        let timer = Timer(timeInterval: timeInterval, target: self, selector: #selector(changePicture), userInfo: userInfo, repeats: true)
        RunLoop.main.add(timer, forMode: RunLoopMode.commonModes)
        self.timer = timer
    }
    /**
    定时器回调方法，用于自动翻页
    */
    func changePicture() {
        // 继续调用协议默认实现
        self.autoChangePicture(self.collectionView)
    }
    
}


// MARK: - scrollView 代理
extension CyclePictureView {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if self.autoScroll {
            self.timer?.invalidate()
            self.timer = nil
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if self.autoScroll {
            self.setupTimer(nil)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let pageControl = self.pageControl else {
            return
        }

        let offsetIndex = self.collectionView.contentOffset.x / self.flowLayout!.itemSize.width
        let currentIndex = Int(offsetIndex.truncatingRemainder(dividingBy: CGFloat(self.imageBox!.imageArray.count)) + 0.5)
        pageControl.currentPage = currentIndex == self.imageBox!.imageArray.count ? 0 :currentIndex
    }

}

// MARK: - collectionView 数据源
extension CyclePictureView {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.actualItemCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! CyclePictureCell
        
        if let placeholderImage = self.placeholderImage {
            cell.placeholderImage = placeholderImage
        }
        
        if let pictureContentMode = self.pictureContentMode {
            cell.pictureContentMode = pictureContentMode
        }
        
        if let imageBox = self.imageBox {
            let actualItemIndex = indexPath.item % imageBox.imageArray.count
            cell.imageSource = imageBox[actualItemIndex]
        }
        
        if let array = self.imageTitleArray {
            let actualItemIndex = indexPath.item % array.count
            cell.imageDetail = array[actualItemIndex]
            // TODO: 好恶心的判决金字塔，不知道有什么办法解决
            if let font = self.detailLableTextFont {
                cell.detailLableTextFont = font
            }
            if let color = self.detailLableTextColor {
                cell.detailLableTextColor = color
            }
            if let backgroundColor = self.detailLableBackgroundColor {
                cell.detailLableBackgroundColor = backgroundColor
            }
            if let height = self.detailLableHeight {
                cell.detailLableHeight = height
            }
            if let aphla = self.detailLableAlpha {
                cell.detailLableAlpha = aphla
            }
            
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index: Int! = indexPath.item % self.imageBox!.imageArray.count
        self.delegate?.cyclePictureView(self, didSelectItemAtIndexPath: IndexPath(item: index, section: indexPath.section))
        NotificationCenter.default.post(name: Notification.Name(rawValue: Common.NOTIFICATION_TOP_CYCLEIMAGE_SELECTION_INDEX), object: nil, userInfo: ["selectIndex": index])
    }
    
}
