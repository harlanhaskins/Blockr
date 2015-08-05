//
//  HostsProcessor.swift
//  Blockr
//
//  Created by Harlan Haskins on 8/5/15.
//  Copyright © 2015 Harlan Haskins. All rights reserved.
//

import Foundation

struct Rule {
    let url: NSURL
    
    var dictionaryRepresentation: [String: AnyObject] {
        return ["action": ["type": "block"], "trigger": ["url-filter": self.url.pathWithoutScheme]]
    }
}

struct HostsProcessor {
    
    // These shouldn't fail...ever.
    static let dataDetector = try! NSDataDetector(types: NSTextCheckingType.Link.rawValue)
    static let commentStripRegex = try! NSRegularExpression(pattern: "#.*$", options: [NSRegularExpressionOptions.AnchorsMatchLines])
    
    static func processHostsFile(completion: ([Rule]?, ErrorType?) -> ()) {
        do {
            let hostsContents = try String(contentsOfURL: NSURL(string: "http://winhelp2002.mvps.org/hosts.txt")!)
            let strippedOfComments = commentStripRegex.stringByReplacingMatchesInString(hostsContents, options: [], range: NSRange(location: 0, length: hostsContents.characters.count), withTemplate: "")
            let matches = dataDetector.matchesInString(strippedOfComments, options: [], range: NSRange(location: 0, length: strippedOfComments.characters.count))
            dispatch_async(dispatch_get_main_queue()) {
                completion(matches.flatMap { $0.URL.map(Rule.init) }, nil)
            }
        } catch {
            dispatch_async(dispatch_get_main_queue()) {
                completion(nil, error)
            }
        }
    }

}