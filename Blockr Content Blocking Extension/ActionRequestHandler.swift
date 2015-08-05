//
//  ActionRequestHandler.swift
//  Blockr Content Blocking Extension
//
//  Created by Harlan Haskins on 8/4/15.
//  Copyright © 2015 Harlan Haskins. All rights reserved.
//

import UIKit
import MobileCoreServices

class ActionRequestHandler: NSObject, NSExtensionRequestHandling {

    func beginRequestWithExtensionContext(context: NSExtensionContext) {
        let url: NSURL?
        if let fileURL = BlockFileManager.fileURL where NSFileManager.defaultManager().fileExistsAtPath(fileURL.absoluteString) {
            url = fileURL
        } else {
            url = NSBundle.mainBundle().URLForResource("blockerList", withExtension: "json")
        }
        NSLog("URL: \(url)")
        let attachment = NSItemProvider(contentsOfURL: url)!
    
        let item = NSExtensionItem()
        item.attachments = [attachment]
    
        context.completeRequestReturningItems([item], completionHandler: nil)
    }
    
}
