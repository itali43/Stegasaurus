//
//  TrailViewController.swift
//  Stegasaurus
//
//  Created by Elliott Williams on 7/24/18.
//  Copyright © 2018 AgrippaApps. All rights reserved.
//

import UIKit
import WKWebViewJavascriptBridge
import WebKit


class TrailViewController: UIViewController {
    var bridge: WKWebViewJavascriptBridge!
    let webView = WKWebView(frame: CGRect(), configuration: WKWebViewConfiguration())

    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.frame = view.bounds
        webView.navigationDelegate = self as? WKNavigationDelegate
        view.addSubview(webView)

        print("The Trial has begun.")
        
        
        
        bridge = WKWebViewJavascriptBridge(webView: webView)
        bridge.register(handlerName: "testiOSCallback") { (paramters, callback) in
            print("testiOSCallback called: \(String(describing: paramters))")
            callback?("Response from testiOSCallback")
        }
        
        bridge.call(handlerName: "testJavascriptHandler", data: ["foo": "before ready"], callback: nil)

        

        
        
        
        
        
        
        print("The Gavel has fallen.")

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadDemoPage()

    }
    
    func loadDemoPage() {
        enum LoadDemoPageError: Error {
            case nilPath
        }
        
        do {
            guard let pagePath = Bundle.main.path(forResource: "Demo", ofType: "html") else {
                throw LoadDemoPageError.nilPath
            }
            let pageHtml = try String(contentsOfFile: pagePath, encoding: .utf8)
            let baseURL = URL(fileURLWithPath: pagePath)
            webView.loadHTMLString(pageHtml, baseURL: baseURL)
        } catch LoadDemoPageError.nilPath {
            print(print("webView loadDemoPage error: pagePath is nil"))
        } catch let error {
            print("webView loadDemoPage error: \(error)")
        }
    }
    
    @objc func callHandler() {
        let data = ["greetingFromiOS": "Hi there, JS!"]
        bridge.call(handlerName: "testJavascriptHandler", data: data) { (response) in
            print("testJavascriptHandler responded: \(String(describing: response))")
        }
    }
    
    @objc func reloadWebView() {
        webView.reload()
    }


}


extension ViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("webViewDidStartLoad")
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("webViewDidFinishLoad")
    }
}
