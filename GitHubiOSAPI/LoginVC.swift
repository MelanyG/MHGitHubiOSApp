//
//  LoginVC.swift
//  GitHubiOSAPI
//
//  Created by Melaniia Hulianovych on 4/11/17.
//  Copyright © 2017 Melaniia Hulianovych. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {
    
    
    @IBOutlet weak var loginTextView: UITextField!
    @IBOutlet weak var passwordTextView: UITextField!
    
    
    
    @objc override func viewDidLoad() {
        super.viewDidLoad()
  
        let nc = NotificationCenter.default
        nc.addObserver(forName:authNotification,
                       object:nil, queue:nil,
                       using:catchNotification)
        
    }
    
    
    func catchNotification(notification:Notification) -> Void {
        print("Catch notification")
        ServerManager.shared.getAccessToken()
        NotificationCenter.default.removeObserver(self, name: authNotification, object: nil)
    }
    
    
    
    @IBAction func loginPressed(_ sender: Any) {
        
        if let login = loginTextView.text, let pass = passwordTextView.text {

        }
        if (ServerManager.shared.authCode != nil) {
        
        } else {
           login()
        }
    }
    
    func login() {
        let sb = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "Authorisation")
        
        
        vc.modalPresentationStyle = .popover
        
        let popover = vc.popoverPresentationController
        popover?.delegate = self as? UIPopoverPresentationControllerDelegate
        popover?.permittedArrowDirections = .any
        popover?.sourceView = self.view
        
        present(vc, animated: true, completion: nil)
        view.addSubview(vc.view)

    }
    
    // MARK: - Key-Value Observing
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == #keyPath(ServerManager.shared.authCode) {
            ServerManager.shared.getAccessToken()
           
        }
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
