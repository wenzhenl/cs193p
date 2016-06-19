//
//  WebViewController.swift
//  Smashtag
//
//  Created by Wenzheng Li on 9/20/15.
//  Copyright © 2015 Wenzheng Li. All rights reserved.
//

import UIKit

class WebViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet weak var webView: UIWebView!
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var url: NSURL? {
        didSet {
            if view.window != nil {
                loadURL()
            }
        }
    }
    private func loadURL() {
        if url != nil {
            webView.loadRequest(NSURLRequest(URL: url!))
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.delegate = self
        webView.scalesPageToFit = true
        loadURL()

        // Do any additional setup after loading the view.
    }

    // MARK: - UIWebView delegate
    
    var activeDownloads = 0
    
    func webViewDidStartLoad(webView: UIWebView) {
        activeDownloads++
        spinner.startAnimating()
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        activeDownloads--
        if activeDownloads < 1 {
            spinner.stopAnimating()
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
