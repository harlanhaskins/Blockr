//
//  BlockFileManahger.swift
//  Blockr
//
//  Created by Harlan Haskins on 8/5/15.
//  Copyright © 2015 Harlan Haskins. All rights reserved.
//

import Foundation

enum BlockFileManagerError: ErrorType {
    case FileNotFound
}

struct BlockFileManager {
    static let fileURL: NSURL? = {
        if let dir = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, [.AllDomainsMask], true).first {
            return NSURL.fileURLWithPath(dir.stringByAppendingPathComponent("blockList.json"))
        }
        return nil
    }()
    
    static func writeJSON(string: String) throws {
        if let fileURL = fileURL {
            try string.writeToURL(fileURL, atomically: true, encoding: NSUTF8StringEncoding)
        } else {
            throw BlockFileManagerError.FileNotFound
        }
    }
    
}