//
//  LoadCircleAnimateView.swift
//  CLQZhihuDaily
//
//  Created by 崔岚清 on 2017/3/6.
//  Copyright © 2017年 cuilanqing. All rights reserved.
//

import UIKit

class LoadCircleAnimateView: UIView {
    
    private var currentRatio: CGFloat!
    private var backgroundCircleLayer: CAShapeLayer!
    private var circleLayer: CAShapeLayer!

    override init(frame: CGRect) {
        super.init(frame: frame)
        currentRatio = 0.0
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.addCircleLayers()
    }

    func addCircleLayers() {
        let path = UIBezierPath(arcCenter: CGPoint(x: self.frame.size.width / 2, y: self.frame.size.height / 2), radius: self.frame.size.height*0.5, startAngle: CGFloat(M_PI_2), endAngle: CGFloat(M_PI*2.5), clockwise: true)
        backgroundCircleLayer = CAShapeLayer()
        backgroundCircleLayer.path = path.cgPath
        backgroundCircleLayer.fillColor = UIColor.clear.cgColor
        backgroundCircleLayer.strokeColor = UIColor.gray.cgColor
        backgroundCircleLayer.lineCap = kCALineCapRound
        backgroundCircleLayer.lineWidth = 1.5
        backgroundCircleLayer.strokeEnd = 1.0
        backgroundCircleLayer.zPosition = -1
        
        circleLayer = CAShapeLayer()
        circleLayer.path = path.cgPath
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.strokeColor = UIColor.white.cgColor
        circleLayer.lineCap = kCALineCapRound
        circleLayer.lineWidth = 2.0
        circleLayer.zPosition = 1
        // 设置前景circleLayer的strokeEnd为0，防止其在刚初始化后就显示
        circleLayer.strokeEnd = 0.0
        
        self.layer.addSublayer(circleLayer)
        self.layer.addSublayer(backgroundCircleLayer)
    }
    
    func updateCircle(byRatio: CGFloat) {
        let pathAnimation = CABasicAnimation(keyPath: "strokeEnd")
        pathAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        pathAnimation.fromValue = self.currentRatio
        pathAnimation.toValue = byRatio
        circleLayer.strokeEnd = byRatio
        
        circleLayer.add(pathAnimation, forKey: "strokeEndAnimation")
        
        self.currentRatio = byRatio
    }
    
}
