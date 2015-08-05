//
//  HostsProcessor.swift
//  Blockr
//
//  Created by Harlan Haskins on 8/5/15.
//  Copyright © 2015 Harlan Haskins. All rights reserved.
//

import Foundation

struct Rule: RawRepresentable {
    let rule: String
    typealias RawValue = [String: AnyObject]
    
    init?(rawValue: RawValue) {
        if let
            trigger = rawValue["trigger"] as? [String: AnyObject],
            rule = trigger["url-filter"] as? String {
                self.init(rule: rule)
        }
        return nil
    }
    
    init(rule: String) {
        self.rule = rule.regexForURLContainingSelf
    }
    
    var rawValue: RawValue {
        return ["action": ["type": "block"], "trigger": ["url-filter": self.rule]]
    }
}

struct HostsProcessor {
    
    // These shouldn't fail...ever.
    static let dataDetector = try! NSDataDetector(types: NSTextCheckingType.Link.rawValue)
    static let commentStripRegex = try! NSRegularExpression(pattern: "#.*$", options: [NSRegularExpressionOptions.AnchorsMatchLines])
    
    static func processHostsFile(completion: ([Rule]?, ErrorType?) -> ()) {
        dispatch_async(dispatch_get_global_queue(0, 0)) {
            do {
                let hostsContents = try String(contentsOfURL: NSURL(string: "http://winhelp2002.mvps.org/hosts.txt")!)
                let strippedOfComments = commentStripRegex.stringByReplacingMatchesInString(hostsContents, options: [], range: NSRange(location: 0, length: hostsContents.characters.count), withTemplate: "")
                let matches = dataDetector.matchesInString(strippedOfComments, options: [], range: NSRange(location: 0, length: strippedOfComments.characters.count))
                dispatch_async(dispatch_get_main_queue()) {
                    let strings = matches.flatMap { $0.URL?.pathWithoutScheme }
                    completion(strings.map(Rule.init), nil)
                }
            } catch {
                dispatch_async(dispatch_get_main_queue()) {
                    completion(nil, error)
                }
            }
        }
    }
}

extension NSURL {
    var pathWithoutScheme: String {
        return self.absoluteString.stringByReplacingOccurrencesOfString("\(self.scheme)://", withString: "")
    }
}

extension String {
    var regexForURLContainingSelf: String {
        return "https?://(www.)?\(self).*"
    }
}