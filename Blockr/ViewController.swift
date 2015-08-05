//
//  ViewController.swift
//  Blockr
//
//  Created by Harlan Haskins on 8/4/15.
//  Copyright © 2015 Harlan Haskins. All rights reserved.
//

import UIKit
import SafariServices

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
            HostsProcessor.processHostsFile { rules, error in
                self.activityIndicator.stopAnimating()
                if let error = error {
                    self.textView.text = "\(error)"
                } else if let rules = rules {
                    do {
                        let data = try NSJSONSerialization.dataWithJSONObject(rules.map { $0.rawValue }, options: [])
                        let string = NSString(data: data, encoding: NSUTF8StringEncoding) as! String
                        self.textView.text = string
                        try BlockFileManager.writeJSON(string)
                        SFContentBlockerManager.reloadContentBlockerWithIdentifier("com.harlan.block.extension") { error in
                            print(error)
                        }
                    } catch {
                        print(error)
                    }
            }
        }
    }
    
    @IBOutlet weak var textView: UITextView!
    
}

