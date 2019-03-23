//
//  ViewController.swift
//  Project4
//
//  Created by Alexis Orellano on 3/22/19.
//  Copyright © 2019 Alexis Orellano. All rights reserved.
//

import UIKit
import WebKit

class DetailViewController: UIViewController, WKNavigationDelegate {
    var webView: WKWebView!
    var progressiveView: UIProgressView!
    var selectedWebsite: String?
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = URL(string: "https://" + selectedWebsite!)!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open", style: .plain, target: self, action: #selector(openTapped))
        
        progressiveView = UIProgressView(progressViewStyle: .default)
        progressiveView.sizeToFit()
        
        let progressButton = UIBarButtonItem(customView: progressiveView)
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
        let back = UIBarButtonItem(title: "Back", style: .plain, target: webView, action: #selector(webView.goBack))
        let foward = UIBarButtonItem(title: "Foward", style: .plain, target: webView, action: #selector(webView.goForward))
        
        toolbarItems = [back,progressButton, spacer, refresh, foward]
        navigationController?.isToolbarHidden = false
    }
    
    @objc func openTapped(){
        let ac = UIAlertController(title: "Open page...", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: selectedWebsite, style: .default, handler: openPage))

        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        ac.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
        present(ac, animated: true)
    }
    
    func openPage(action: UIAlertAction){
        let url = URL(string: "https://" + action.title!)!
        webView.load(URLRequest(url: url))
        
    }
    
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        title = webView.title
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let url = navigationAction.request.url
        
        if let host = url?.host {
            //for website in websites {
                if host.contains(selectedWebsite!){
                    decisionHandler(.allow)
                    return
                //}
            }
        }
        let ac = UIAlertController(title: "Blocked", message: "This website is blocked", preferredStyle: .alert
        )
        ac.addAction(UIAlertAction(title: "OK", style: .cancel))
        present(ac, animated: true)
        decisionHandler(.cancel)
    }
}

