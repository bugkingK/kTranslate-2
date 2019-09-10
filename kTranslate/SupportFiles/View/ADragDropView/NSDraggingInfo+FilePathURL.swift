//
//  NSDraggingInfo+FilePathURL.swift
//  kTranslate
//
//  Created by moon on 10/09/2019.
//  Copyright © 2019 bugking. All rights reserved.
//

import Foundation
import AppKit

extension NSDraggingInfo {
    var filePathURLs: [URL] {
        var filenames : [String]?
        var urls: [URL] = []
        
        filenames = draggingPasteboard.propertyList(forType: NSPasteboard.PasteboardType("NSFilenamesPboardType")) as? [String]
        
        if let filenames = filenames {
            for filename in filenames {
                urls.append(URL(fileURLWithPath: filename))
            }
            return urls
        }
        
        return []
    }
}
