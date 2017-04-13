//
//  AuthorisationVC.swift
//  GitHubiOSAPI
//
//  Created by Melaniia Hulianovych on 4/12/17.
//  Copyright © 2017 Melaniia Hulianovych. All rights reserved.
//

import UIKit

let authNotification = Notification.Name(rawValue:"AuthCodeReceived")

class AuthorisationVC: UIViewController, UIWebViewDelegate {
    

    
    @IBOutlet weak var webView: UIWebView!
    var token = GitHubAccessToken()
    
    var request: URLRequest!

    override func viewDidLoad() {
        super.viewDidLoad()

        let urlString = "https://github.com/login/oauth/authorize?scope=nil&client_id=ea5679f04f9686902f10"
        let url = URL(string: urlString)
        request = URLRequest(url: url!)
        webView.delegate = self
        webView.loadRequest(request)
        
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
    
        if token.authCode == nil {
            if (request.url?.description.range(of:"code=")) != nil {
                let code = request.url?.absoluteString.components(separatedBy:"=").last
                ServerManager.shared.token.authCode = code

                let nc = NotificationCenter.default
                nc.post(name:authNotification,
                        object: nil,
                        userInfo: nil)
                dismiss(animated: true, completion: nil)
                return false
            }
            return true
        }
        
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
