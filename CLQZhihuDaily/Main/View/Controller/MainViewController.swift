//
//  MainViewController.swift
//  CLQZhihuDaily
//
//  Created by 崔岚清 on 2017/2/10.
//  Copyright © 2017年 cuilanqing. All rights reserved.
//  主容器

import UIKit
import ReactiveSwift
import Result
import SDWebImage

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
    var pullDistance: CGFloat!
    let cellHeight: CGFloat = 110
    let topScrollViewHeight: CGFloat = 220
    let prelude: CGFloat = 90
    let sectionHeaderHeight: CGFloat = 44
    
    @IBOutlet var panGesture: UIPanGestureRecognizer!
    
    // 下拉完成后加载数据的指示器view
    var loadingActivityView: UIActivityIndicatorView!
    var loadCircleAnimatedView: LoadCircleAnimateView!
    // 导航栏标题View
    var navTitleView: UIView!
    var navTitleLabel: UILabel!
    // 顶部轮播图片view
    var cyclePictureView: CyclePictureView!
    var storyViewModel: StoryViewModel!
    /* 判断下拉是否完成并进入刷新状态 */
    var refreshTrigger: Bool!
    
    /// 记录是否在加载往期的数据，用以防止上拉刷新时多次调用刷新方法
    var isLoadingPreviousData: Bool = false
    
    /* 第二个section的offsetY，用于隐藏NavBar */
    lazy var secondSectionOffsetY: CGFloat = {
        let n = CGFloat(self.storyTableView.numberOfRows(inSection: 0)) * self.cellHeight + self.topScrollViewHeight + self.sectionHeaderHeight
        return n
    }()
    
    lazy var storyTableView: UITableView = {
        let tmpTableView = UITableView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), style: .plain);
        return tmpTableView;
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navTitleView = UIView()
        navTitleView.frame = CGRect(x: 0, y: 0, width: 120, height: 40)
        
        navTitleLabel = UILabel()
        navTitleLabel.textAlignment = .left
        navTitleLabel.textColor = UIColor.white
        navTitleLabel.font = UIFont.systemFont(ofSize: 17)
        navTitleLabel.text = "今日热闻"
        navTitleLabel.frame = CGRect(x: 26, y: 0, width: 80, height: 40)
        
        loadingActivityView = UIActivityIndicatorView(activityIndicatorStyle: .white)
        loadingActivityView.frame = CGRect(x: 3, y: 11, width: 20, height: 20)
        
        loadCircleAnimatedView = LoadCircleAnimateView()
        loadCircleAnimatedView.frame = CGRect(x: 3, y: 11, width: 17, height: 17)
        
        navTitleView.addSubview(navTitleLabel)
        navTitleView.addSubview(loadCircleAnimatedView)
        navTitleView.addSubview(loadingActivityView)
        self.navigationItem.titleView = navTitleView
        loadCircleAnimatedView.isHidden = true
        refreshTrigger = false
        
        self.automaticallyAdjustsScrollViewInsets = false
        pullDistance = UIApplication.shared.statusBarFrame.size.height + (self.navigationController?.navigationBar.frame.size.height)!
        
        self.view.backgroundColor = UIColor.gray;
        storyViewModel = StoryViewModel()
        
        self.storyTableView.register(UINib(nibName: "ListStoryCell", bundle: nil), forCellReuseIdentifier: "storyCell")
        self.storyTableView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        self.storyTableView.contentInset = UIEdgeInsetsMake(-self.pullDistance, 0, 0, 0)
        self.storyTableView.delegate = self
        self.storyTableView.dataSource = self
        self.storyTableView.showsVerticalScrollIndicator = false
        self.storyTableView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 15);
        self.storyTableView.separatorColor = UIColor(colorLiteralRed: 235/255, green: 235/255, blue: 235/255, alpha: 1.0);
        
        // 适配iOS11
        if #available(iOS 11.0, *) {
            self.storyTableView.contentInsetAdjustmentBehavior = .never
        }
        
        self.view.addSubview(self.storyTableView)
        
        setNavigationBarTransparent()
        
        setUpCycleImageScrollView()
        
        storyViewModel.fetchLatestStories()
        
        NotificationCenter.default.addObserver(self, selector: #selector(fetchLatestStoriesCompletionHandler), name: NSNotification.Name(rawValue: Common.NOTIFICATION_FETCH_LATEST_STORIES_COMPLETE), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(fetchPreviousStoriesCompletionHandler), name: NSNotification.Name(rawValue: Common.NOTIFICATION_FETCH_PREVIOUS_STORIES_COMPLETE), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(topImageSelectionHandler(note:)), name: Notification.Name(rawValue: Common.NOTIFICATION_TOP_CYCLEIMAGE_SELECTION_INDEX), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = false
        
        UIApplication.shared.statusBarStyle = .lightContent
        self.setStatusBarBackgroundColor(color: UIColor.clear)
        
        self.storyTableView.reloadData()
    }
    
    func fetchLatestStoriesCompletionHandler() {
        // 先加载一次往期数据
        self.loadPreviousData()
        
        self.cyclePictureView.imageURLArray = self.storyViewModel.topStoryImageUrls
        self.cyclePictureView.imageTitleArray = self.storyViewModel.topStoryImageTitles
        self.storyTableView.reloadData()
        
        self.loadCircleAnimatedView.updateCircle(byRatio: 0)
        self.refreshTrigger = false
        self.loadingActivityView.stopAnimating()
        self.storyTableView.contentOffset.y = self.pullDistance
    }
    
    func fetchPreviousStoriesCompletionHandler() {
        self.isLoadingPreviousData = false
        self.storyTableView.reloadData()
    }
    
    /// 设置tableView顶部的轮播图片
    func setUpCycleImageScrollView() {
        let cyclePictureContainerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: topScrollViewHeight+pullDistance))
        cyclePictureView = CyclePictureView(frame: CGRect(x: 0, y: pullDistance, width: self.view.frame.width, height: topScrollViewHeight), imageURLArray: nil)
        cyclePictureView.backgroundColor = UIColor.red
        cyclePictureView.currentDotColor = UIColor.white
        cyclePictureView.otherDotColor = UIColor.lightGray
        cyclePictureView.timeInterval = 3.5
        cyclePictureView.pictureContentMode = .scaleAspectFill
        cyclePictureContainerView.addSubview(cyclePictureView)
        self.storyTableView.tableHeaderView = cyclePictureContainerView
    }
    
    /// 设置navBar透明
    func setNavigationBarTransparent() {
        self.navigationController?.navigationBar.clq_setBackgroundColor(backgroundColor: UIColor.clear)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return storyViewModel.listStoryModels.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        }
        return sectionHeaderHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionHeaderView = SectionHeaderView()
        sectionHeaderView.titleLabel.text = storyViewModel.sectionTitlesArray[section]
        
        return sectionHeaderView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return storyViewModel.listStoryModels[section].count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "storyCell", for: indexPath) as! ListStoryCell
        
        cell.titleLabel.text = storyViewModel.listStoryModels[indexPath.section][indexPath.row].title
        cell.readed = storyViewModel.listStoryModels[indexPath.section][indexPath.row].readed
        let imgUrl = (storyViewModel.listStoryModels[indexPath.section][indexPath.row].images).object(at: 0) as! String
        cell.storyImageView.sd_setImage(with: URL(string: imgUrl))

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        storyViewModel.selectedIndexPath = indexPath
        
        let model = storyViewModel.listStoryModels[indexPath.section][indexPath.row]
        model.readed = true
        let cell = tableView.cellForRow(at: indexPath) as! ListStoryCell
        cell.readed = true
        
        self.fetchDetailStoryData(withId: model.storyId)
        
        let storyDetailVC = StoryDetailViewController()
        storyDetailVC.storyViewModel = storyViewModel
        self.navigationController?.pushViewController(storyDetailVC, animated: true)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if self.storyTableView.contentOffset.y <= 0 && !refreshTrigger {
            refreshLatestStory()
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (scrollView.isKind(of: UITableView.self)) {
            var offset = scrollView.contentOffset
            let offsetY = offset.y
            print(offsetY)
            if offsetY < pullDistance {
                if !refreshTrigger {
                    self.loadCircleAnimatedView.isHidden = false
                    self.loadCircleAnimatedView.updateCircle(byRatio: (pullDistance-offsetY)/pullDistance)
                }

                /* 固定tableView bounces的最大距离 */
                if (offsetY <= 0.0) {
                    offset.y = 0.0
                    scrollView.setContentOffset(offset, animated: false)
                }

                if offsetY > 0.0 {
                    var frame = cyclePictureView.frame
                    frame.origin.y = offsetY
                    frame.size.height = topScrollViewHeight + (pullDistance - offsetY)
                    cyclePictureView.frame = frame
                }
            }else {
                self.loadCircleAnimatedView.isHidden = true
            }

            if offsetY >= 0 {
                /* NavBar透明度渐变 */
                let alpha = min(1, (offsetY - (self.pullDistance + 20)) / ((self.pullDistance + 20) + prelude))
                self.navigationController?.navigationBar.clq_setBackgroundColor(backgroundColor: Common.GLOBAL_COLOR_BLUE.withAlphaComponent(alpha))

                /* 获取往期的story */
                if offsetY > scrollView.contentSize.height - self.view.bounds.size.height - 2*self.cellHeight {
                    /* 如果不加判断，下拉到临界位置时，load方法会被多次调用 */
                    if !self.isLoadingPreviousData {
                        loadPreviousData()
                    }
                }
            }

            if offsetY > self.secondSectionOffsetY {
                self.storyTableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0)
                self.navTitleLabel.text = ""
                self.navigationController?.navigationBar.clq_setBackgroundLayerHeight(height: 20)
            }else {
                self.storyTableView.contentInset = UIEdgeInsetsMake(-self.pullDistance, 0, 0, 0)
                self.navTitleLabel.text = "今日热闻"
                self.navigationController?.navigationBar.clq_setBackgroundLayerHeight(height: self.pullDistance)
            }
        }
    }
    
    /// 下拉刷新获取最新数据
    func refreshLatestStory() {
        self.loadCircleAnimatedView.isHidden = true
        self.refreshTrigger = true
        loadingActivityView.startAnimating()
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + DispatchTimeInterval.milliseconds(500), execute: {
            self.storyViewModel.fetchLatestStories()
        })
    }
    
    /// 接收到选择顶部轮播图片cell通知
    ///
    /// - Parameter note: 通知
    func topImageSelectionHandler(note: Notification) {
        let selectedIndex: Int = note.userInfo!["selectIndex"] as! Int
        let firstLevelArray: Array<TopStoryBriefModel> = self.storyViewModel.topStoryModels[0]
        let topModel: TopStoryBriefModel = firstLevelArray[selectedIndex]
        let topStoryId: UInt64 = topModel.storyId
        for i in 0 ..< self.storyViewModel.listStoryModels.count {
            for j in 0 ..< self.storyViewModel.listStoryModels[i].count {
                let model = self.storyViewModel.listStoryModels[i][j]
                if model.storyId == topStoryId {
                    // 找出与选中的topStory的id对应的listStory
                    self.storyViewModel.selectedIndexPath = IndexPath(row: j, section: i)
                    model.readed = true
                    
                    self.fetchDetailStoryData(withId: model.storyId)
                    
                    let storyDetailVC = StoryDetailViewController()
                    storyDetailVC.storyViewModel = storyViewModel
                    self.navigationController?.pushViewController(storyDetailVC, animated: true)
                    break
                }
            }
        }
    }
    
    /// 获取往期数据
    func loadPreviousData() {
        self.isLoadingPreviousData = true
        storyViewModel.fetchPreviousStories()
    }
    
    func fetchDetailStoryData(withId: UInt64) {
        storyViewModel.fetchDetailStory(withId: withId)
        storyViewModel.fetchDetailStoryExtraInfo(withId: withId)
    }
    
    func setStatusBarBackgroundColor(color: UIColor) {
        let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
        
        if statusBar.responds(to: #selector(setter: UIView.backgroundColor)) {
            UIView.animate(withDuration: 0.2, animations: {
                statusBar.backgroundColor = color
            })
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}
