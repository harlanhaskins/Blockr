//
//  ViewController.swift
//  Blockr
//
//  Created by Harlan Haskins on 8/4/15.
//  Copyright © 2015 Harlan Haskins. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func loadHosts(sender: UIButton) {
        activityIndicator.startAnimating()
        dispatch_async(dispatch_get_global_queue(0, 0)) {
            HostsProcessor.processHostsFile { rules, error in
                self.activityIndicator.stopAnimating()
                if let error = error {
                    self.textView.text = "\(error)"
                } else if let rules = rules {
                    do {
                        let data = try NSJSONSerialization.dataWithJSONObject(rules.map { $0.dictionaryRepresentation }, options: [.PrettyPrinted])
                    self.textView.text = NSString(data: data, encoding: NSUTF8StringEncoding) as! String
                    } catch {
                        print(error)
                    }
                }
            }
        }
    }
    
    @IBOutlet weak var textView: UITextView!

}

extension NSURL {
    var pathWithoutScheme: String {
        return self.absoluteString.stringByReplacingOccurrencesOfString("\(self.scheme)://", withString: "")
    }
}

