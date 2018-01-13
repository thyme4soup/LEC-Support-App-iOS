//
//  WebView.swift
//  LEC Support App
//
//  Created by Michael Chenevey on 6/12/17.
//  Copyright © 2017 Living Earth Crafts. All rights reserved.
//

import UIKit

class WebView: UIViewController {
    
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = NSURL (string: "http://www.livingearthcrafts.com");
        let requestObj = NSURLRequest(url: url! as URL);
        webView.loadRequest(requestObj as URLRequest);
        webView.scalesPageToFit = true
        print("loaded")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
