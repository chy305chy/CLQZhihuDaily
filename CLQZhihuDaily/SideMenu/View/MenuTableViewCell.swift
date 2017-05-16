//
//  MenuTableViewCell.swift
//  CLQZhihuDaily
//
//  Created by 崔岚清 on 2017/5/15.
//  Copyright © 2017年 cuilanqing. All rights reserved.
//

import UIKit
import SnapKit

class MenuTableViewCell: UITableViewCell {
    
    @IBOutlet weak var leftImageView: UIImageView!
    @IBOutlet weak var menuLabel: UILabel!
    @IBOutlet weak var rightImageView: UIImageView!
    
    var leftImageViewHidden: Bool! {
        didSet {
            self.leftImageView.isHidden = self.leftImageViewHidden

            if self.leftImageViewHidden {
                self.menuLabel.snp.updateConstraints { (make) in
                    make.left.equalTo(self.snp.left).offset(15)
                }
            }else {
                self.menuLabel.snp.updateConstraints { (make) in
                    make.left.equalTo(self.snp.left).offset(45)
                }
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.menuLabel.textColor = Common.SIDEBAR_TEXTCOLOR
        self.backgroundColor = UIColor.clear
        
        self.leftImageView.snp.makeConstraints { (make) in
            make.width.equalTo(20)
            make.height.equalTo(20)
            make.left.equalTo(self.snp.left).offset(15)
            make.centerY.equalTo(self.snp.centerY)
        }
        
        self.rightImageView.snp.makeConstraints { (make) in
            make.width.equalTo(15)
            make.height.equalTo(18)
            make.centerY.equalTo(self.snp.centerY)
            make.right.equalTo(self.snp.right).offset(-45)
        }
        
        self.menuLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.snp.left).offset(45)
            make.right.equalTo(self.snp.right).offset(-60)
            make.top.equalTo(self.snp.top)
            make.bottom.equalTo(self.snp.bottom)
        }
        
        self.leftImageViewHidden = true
        let bgView: UIView = UIView(frame: self.bounds)
        bgView.backgroundColor = Common.SIDEBAR_SEPLINE_COLOR
        self.selectedBackgroundView = bgView
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
