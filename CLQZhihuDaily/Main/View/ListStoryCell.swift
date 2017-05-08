//
//  ListStoryCell.swift
//  CLQZhihuDaily/Users/cuilanqing/Desktop/DemoProject/CLQZhihuDaily/CLQZhihuDaily/Main/View/ListStoryCell.swift
//
//  Created by cuilanqing on 2017/2/18.
//  Copyright © 2017年 cuilanqing. All rights reserved.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa

class ListStoryCell: UITableViewCell {
    
    @IBOutlet weak var storyImageView: UIImageView!
    
    lazy var titleLabel: ListStoryTitleTextView = {
        let tmpTextView = ListStoryTitleTextView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), textContainer: nil)
        tmpTextView.storyCell = self
        return tmpTextView
    }()
    
    // 用户是否阅读过详情
    var readed: Bool! {
        didSet {
            if readed! {
                self.titleLabel.textColor = UIColor.darkGray
            }else {
                self.titleLabel.textColor = UIColor.black
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        self.readed = false
        self.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.snp.left).offset(10)
            make.top.equalTo(self.snp.top).offset(10)
            make.bottom.equalTo(self.snp.bottom).offset(-10)
            make.right.equalTo(self.storyImageView.snp.left).offset(-10)
        }
        
        storyImageView.snp.makeConstraints { (make) in
            make.top.equalTo(self.snp.top).offset(20)
            make.right.equalTo(self.snp.right).offset(-15)
            make.bottom.equalTo(self.snp.bottom).offset(-20)
            make.width.equalTo(self.storyImageView.snp.height)
        }
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
