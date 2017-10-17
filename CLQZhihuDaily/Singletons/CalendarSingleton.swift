//
//  CalendarSingleton.swift
//  CLQZhihuDaily
//
//  Created by 崔岚清 on 2017/2/25.
//  Copyright © 2017年 cuilanqing. All rights reserved.
//

import UIKit

class CalendarSingleton: NSCalendar {
    static let sharedGregorianCalendar = NSCalendar(calendarIdentifier: .gregorian)
    
    private override init?(calendarIdentifier ident: NSCalendar.Identifier) {
        super.init(calendarIdentifier: ident)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
