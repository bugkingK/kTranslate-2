//
//  CommonUtil.swift
//  AirPodsManager
//
//  Created by bugking on 07/06/2019.
//  Copyright © 2019 bugking. All rights reserved.
//

import Cocoa

class CommonUtil: NSObject {
    
    static func alertMessage(_ alert_msg:String, _ alert_infoText:String? = nil){
        let alert = NSAlert()
        alert.messageText = alert_msg
        alert.informativeText = alert_infoText ?? ""
        alert.runModal()
    }
    
    static func alertMessageWithDelete(_ alert_msg:String, _ alert_infoText:String? = nil, ok_event:()->()) {
        let alert = NSAlert()
        alert.messageText = alert_msg
        alert.addButton(withTitle: "Delete")
        alert.addButton(withTitle: "Cancel")
        alert.informativeText = alert_infoText ?? ""
        let response = alert.runModal()
        switch response {
        case NSApplication.ModalResponse.alertFirstButtonReturn:
            ok_event()
        default:
            break;
        }
    }
    
    static func alertMessageWithConfirm(_ alert_msg:String, _ alert_infoText:String? = nil, ok_event:()->()) {
        let alert = NSAlert()
        alert.messageText = alert_msg
        alert.addButton(withTitle: "Confirm")
        alert.addButton(withTitle: "Cancel")
        alert.informativeText = alert_infoText ?? ""
        let response = alert.runModal()
        switch response {
        case NSApplication.ModalResponse.alertFirstButtonReturn:
            ok_event()
        default:
            break;
        }
    }
    
    static func alertMessageWithKeep(_ alert_msg:String, _ alert_infoText:String? = nil, ok_event:()->()) {
        let alert = NSAlert()
        alert.messageText = alert_msg
        alert.addButton(withTitle: "Don't show")
        alert.addButton(withTitle: "Keep")
        alert.informativeText = alert_infoText ?? ""
        alert.window.level = .screenSaver
        let response = alert.runModal()
        switch response {
        case NSApplication.ModalResponse.alertFirstButtonReturn:
            ok_event()
        default:
            break;
        }
    }
    
    static func getCurrentDate() -> String {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yy.MM.dd"
        let now = dateFormatter.string(from: date)
        return now
    }
}
