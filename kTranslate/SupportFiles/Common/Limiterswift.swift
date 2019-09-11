//
//  Limiterswift.swift
//  kTranslate
//
//  Created by moon on 11/09/2019.
//  Copyright © 2019 bugking. All rights reserved.
//

import Foundation

class Limiter: NSObject {
    
    init(interval:TimeInterval) {
        super.init()
        self.timeInterval = interval
    }

    fileprivate var timeInterval:TimeInterval = 3
    fileprivate var m_is_allow:Bool = true
    
    public func start() {
        self.m_is_allow = false
        Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: false) { (timer) in
            self.m_is_allow = true
        }
    }
    
    public func allow() -> Bool {
        return m_is_allow
    }
}
