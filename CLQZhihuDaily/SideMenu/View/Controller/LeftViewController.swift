//
//  LeftViewController.swift
//  CLQZhihuDaily
//
//  Created by 崔岚清 on 2017/2/10.
//  Copyright © 2017年 cuilanqing. All rights reserved.
//  左侧的容器

import UIKit

class LeftViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let menuItems = ["首页", "日常心理学", "设计日报", "用户推荐日报", "电影日报", "不许无聊", "大公司日报", "财经日报", "互联网安全", "开始游戏", "音乐日报", "动漫日报", "体育日报"]
    
    lazy var accountLoginView: AccountLoginView = {
        let tmpV: AccountLoginView = AccountLoginView(frame: CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: 70))
        return tmpV
    }()
    
    lazy var settingFavMsgView: SettingFavoriteMsgView = {
        let tmpV: SettingFavoriteMsgView = SettingFavoriteMsgView(frame: CGRect.init(x: 0, y: 80, width: Common.leftViewWidth, height: 51))
        return tmpV
    }()
    
    lazy var menuTableView: UITableView = {
        let tmpTableView: UITableView = UITableView(frame: CGRect.init(x: 0, y: 131, width: Common.leftViewWidth, height: 100), style: .plain)
        tmpTableView.backgroundColor = UIColor.clear
        tmpTableView.showsVerticalScrollIndicator = false
        tmpTableView.register(UINib.init(nibName: "MenuTableViewCell", bundle: nil), forCellReuseIdentifier: "MenuTableViewCellIdentifier")
        tmpTableView.separatorStyle = .none
        tmpTableView.delegate = self
        tmpTableView.dataSource = self
        
        return tmpTableView
    }()
    
    lazy var bottomView: BottomView = {
        let tmpBottomV: BottomView = BottomView(frame: CGRect.init(x: 0, y: self.view.frame.size.height - 70, width: Common.leftViewWidth, height: 70))
        
        return tmpBottomV
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = Common.SIDEBAR_BGCOLOR;
        
        self.view.addSubview(self.accountLoginView)
        self.view.addSubview(self.settingFavMsgView)
        self.view.addSubview(self.menuTableView)
        
        menuTableView.snp.makeConstraints { (make) in
            make.left.equalTo(self.view.snp.left)
            make.top.equalTo(self.settingFavMsgView.snp.bottom)
            make.width.equalTo(Common.leftViewWidth)
            make.bottom.equalTo(self.view.snp.bottom).offset(-70)
        }
        
//        let tableBottomMaskView: UIImageView = UIImageView(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0))
//        tableBottomMaskView.image = UIImage(named: "Dark_Menu_Mask")
//        tableBottomMaskView.alpha = 0.7
//        self.view.addSubview(tableBottomMaskView)
//        tableBottomMaskView.snp.makeConstraints { (make) in
//            make.left.equalTo(self.view.snp.left)
//            make.right.equalTo(self.view.snp.right)
//            make.bottom.equalTo(self.menuTableView.snp.bottom)
//            make.height.equalTo(80)
//        }
        
        self.view.addSubview(self.bottomView)
        
        self.accountLoginView.addTarget(self, action: #selector(loginHandler), for: .touchUpInside)
    }
    
    func loginHandler() {
        let alert: UIAlertController = UIAlertController(title: nil, message: "请登录", preferredStyle: .alert)
        let action: UIAlertAction = UIAlertAction(title: "确定", style: .default) { (action) in
            
        }
        alert.addAction(action)
        self.view.window?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MenuTableViewCell = tableView.dequeueReusableCell(withIdentifier: "MenuTableViewCellIdentifier", for: indexPath) as! MenuTableViewCell
        if indexPath.row == 0 {
            cell.leftImageViewHidden = false
        }else {
            cell.leftImageViewHidden = true
        }
        cell.menuLabel.text = menuItems[indexPath.row]
        
        return cell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
