//
//  WebViewController.swift
//  CryptoApp
//
//  Created by Anıl AVCI on 30.01.2023.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    var webView: WKWebView!
    var coinUrl: String?
    override func viewDidLoad() {
        super.viewDidLoad()

        self.edgesForExtendedLayout = []
       
        let config = WKWebViewConfiguration()
        config.allowsInlineMediaPlayback = true
        
        webView = WKWebView(frame: view.bounds, configuration: config)
        self.view = webView
        let request = URLRequest(url: URL(string: coinUrl ?? "")!)
        DispatchQueue.global().async {
            DispatchQueue.main.async {
                self.webView.load(request)
            }
          
        }
       
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
