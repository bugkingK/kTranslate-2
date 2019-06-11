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
}
