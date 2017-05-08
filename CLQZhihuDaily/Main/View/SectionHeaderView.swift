//
//  SectionHeaderView.swift
//  CLQZhihuDaily
//
//  Created by 崔岚清 on 2017/3/2.
//  Copyright © 2017年 cuilanqing. All rights reserved.
//

import UIKit

class SectionHeaderView: UIView {
    
    var titleLabel: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        titleLabel = UILabel()
        titleLabel.backgroundColor = Common.GLOBAL_COLOR_BLUE
        titleLabel.textAlignment = .center
        titleLabel.textColor = UIColor.white
        titleLabel.font = UIFont.systemFont(ofSize: 17)
        self.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { (make) in
            make.edges.equalTo(self.snp.edges)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
