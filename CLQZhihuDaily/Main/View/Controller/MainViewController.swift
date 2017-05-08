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
    var storyBriefViewModel: StoryViewModel!
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
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
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
        storyBriefViewModel = StoryViewModel()
        
        self.storyTableView.register(UINib(nibName: "ListStoryCell", bundle: nil), forCellReuseIdentifier: "storyCell")
        self.storyTableView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        self.storyTableView.contentInset = UIEdgeInsetsMake(-self.pullDistance, 0, 0, 0)
        self.storyTableView.delegate = self
        self.storyTableView.dataSource = self
        self.storyTableView.showsVerticalScrollIndicator = false
        self.storyTableView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 15);
        self.storyTableView.separatorColor = UIColor(colorLiteralRed: 235/255, green: 235/255, blue: 235/255, alpha: 1.0);
        self.view.addSubview(self.storyTableView)
        
        setNavigationBarTransparent()
        
        setUpCycleImageScrollView()
        
        let storySubscriber = Observer<AnyObject, NoError>(value: { (_) in
            self.cyclePictureView.imageURLArray = self.storyBriefViewModel.topStoryImageUrls
            self.cyclePictureView.imageTitleArray = self.storyBriefViewModel.topStoryImageTitles
            self.storyTableView.reloadData()
        }, failed: nil, completed: nil, interrupted: nil)
        storyBriefViewModel.storySignal.observe(storySubscriber)
        storyBriefViewModel.fetchLatestStoriesCommand()
        
        let preStorySubscriber = Observer<AnyObject, NoError>(value: { (value) in
            if value.boolValue! {
                self.isLoadingPreviousData = false
                self.storyTableView.reloadData()
            }
        }, failed: nil, completed: nil, interrupted: nil)
        storyBriefViewModel.preStorySignal.observe(preStorySubscriber)
    }
    
    /// 设置tableView顶部的轮播图片
    func setUpCycleImageScrollView() {
        cyclePictureView = CyclePictureView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: topScrollViewHeight+pullDistance), imageURLArray: nil)
        cyclePictureView.backgroundColor = UIColor.red
        cyclePictureView.currentDotColor = UIColor.white
        cyclePictureView.otherDotColor = UIColor.lightGray
        cyclePictureView.timeInterval = 3.5
        cyclePictureView.pictureContentMode = UIViewContentMode.scaleAspectFill
        self.storyTableView.tableHeaderView = cyclePictureView
    }
    
    /// 设置navBar透明
    func setNavigationBarTransparent() {
        self.navigationController?.navigationBar.clq_setBackgroundColor(backgroundColor: UIColor.clear)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return storyBriefViewModel.listStoryModels.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        }
        return sectionHeaderHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionHeaderView = SectionHeaderView()
        sectionHeaderView.titleLabel.text = storyBriefViewModel.sectionTitlesArray[section]
        
        return sectionHeaderView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return storyBriefViewModel.listStoryModels[section].count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "storyCell", for: indexPath) as! ListStoryCell
        
        cell.titleLabel.text = storyBriefViewModel.listStoryModels[indexPath.section][indexPath.row].title
        let imgUrl = (storyBriefViewModel.listStoryModels[indexPath.section][indexPath.row].images).object(at: 0) as! String
        cell.storyImageView.sd_setImage(with: URL(string: imgUrl))

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = storyBriefViewModel.listStoryModels[indexPath.section][indexPath.row]
        DispatchQueue.main.async {
            self.fetchDetailStoryData(withId: model.storyId)
        }
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
            
            if offsetY < pullDistance {
                if !refreshTrigger {
                    self.loadCircleAnimatedView.isHidden = false
                    self.loadCircleAnimatedView.updateCircle(byRatio: (pullDistance-offsetY)/pullDistance)
                }
                
                /* 固定tableView bounces的最大距离 */
                if (offsetY <= 0) {
                    offset.y = 0
                    scrollView.contentOffset = offset;
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
        
        
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + DispatchTimeInterval.milliseconds(3000), execute: {
            print("获取到最新数据")
            self.loadCircleAnimatedView.updateCircle(byRatio: 0)
            self.refreshTrigger = false
            self.loadingActivityView.stopAnimating()
            self.storyTableView.contentOffset.y = self.pullDistance
        })
    }
    
    /// 获取往期数据
    func loadPreviousData() {
        self.isLoadingPreviousData = true
        storyBriefViewModel.fetchPreviousStoryCommand()
    }
    
    func fetchDetailStoryData(withId: UInt64) {
        storyBriefViewModel.fetchDetailStoryCommand(withId: withId)
    }

}
