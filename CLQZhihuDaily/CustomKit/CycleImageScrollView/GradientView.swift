//
//  GradientView.swift
//  CLQZhihuDaily
//
//  Created by 崔岚清 on 2017/2/22.
//  Copyright © 2017年 cuilanqing. All rights reserved.
//

import UIKit

class GradientView: UIView {

    lazy var gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.frame = self.frame
        layer.borderWidth = 0
        layer.colors = [UIColor.clear.cgColor, UIColor(white: 0, alpha: 0.85).cgColor]
        layer.locations = [NSNumber(floatLiteral: 0.0), NSNumber(floatLiteral: 1.0)]
        return layer
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = UIColor.clear
        self.layer.addSublayer(self.gradientLayer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.gradientLayer.frame = self.bounds
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
