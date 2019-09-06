//
//  Analyst.swift
//  kTranslate
//
//  Created by moon on 06/09/2019.
//  Copyright © 2019 bugking. All rights reserved.
//

import Foundation
import GoogleAnalyticsTracker

class Analyst {
    static let shared = Analyst()
    enum Event:String {
        case launch = "launch"
        case using = "using"
        case translate = "translate"
    }
    
    fileprivate init() {
        MPGoogleAnalyticsTracker.activate(.init(analyticsIdentifier: "UA-141906441-2"))
        MPGoogleAnalyticsTracker.trackEvent(ofCategory: Event.launch.rawValue, action: "-", label: "-", value: 0)
    }
    
    func track(event:Event) {
        MPGoogleAnalyticsTracker.trackEvent(ofCategory: event.rawValue, action: "-", label: "-", value: 0)
    }
    
}
