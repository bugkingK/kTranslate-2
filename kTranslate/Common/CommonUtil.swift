//
//  CommonUtil.swift
//  AirPodsManager
//
//  Created by bugking on 07/06/2019.
//  Copyright © 2019 bugking. All rights reserved.
//

import Cocoa

class CommonUtil: NSObject {
    @discardableResult
    static public func shell(_ args: String) -> String {
        debugPrint(args)
        var outstr = ""
        let task = Process()
        task.launchPath = "/bin/sh"
        task.arguments = ["-c", args]
        let pipe = Pipe()
        task.standardOutput = pipe
        task.launch()
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        
        if let output = String(data: data, encoding: .utf8) {
            outstr = output as String
        }
        task.waitUntilExit()
        return outstr
    }
    
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
}
