//
//  LoginVC.swift
//  GitHubiOSAPI
//
//  Created by Melaniia Hulianovych on 4/11/17.
//  Copyright © 2017 Melaniia Hulianovych. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {

    @IBOutlet weak var signingStackView: UIStackView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nc = NotificationCenter.default
        nc.addObserver(forName:authNotification,
                       object:nil, queue:nil,
                       using:catchNotification)
        
        ServerManager.shared.delegate = self

        if (ServerManager.shared.token.authToken != nil) {
            loadUserData()
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                [weak self] in
                    self?.loadRepositoryVC()
            }
        
        } else {
            signingStackView.isHidden = false
        }
        
    }
    
    
    func catchNotification(notification:Notification) -> Void {
        
        ServerManager.shared.getAccessToken()
        NotificationCenter.default.removeObserver(self, name: authNotification, object: nil)
        loadRepositoryVC()

    }
    
    
    
    @IBAction func loginPressed(_ sender: Any) {

            login()

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
    
    func loadUserData() {
        ServerManager.shared.getAuthentificatedUser() {
            (result: User?) in
            if let user = result {
                DataSource.shared.user = user
                ServerManager.shared.getAllRepositoriesForUser()
            }
            
        }
    }
    
    func loadRepositoryVC() {
        let sb = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "RepositoryVC")
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension LoginVC: ServerManagerDelegate {
    func gotAccessToken() {
        loadUserData()
    }
    
    func updateAccToken() {
        DispatchQueue.main.async {
            [weak self] in
            self?.login()
        }
    }
}


// MARK: - Navigation

//func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//    if segue.identifier == "LoginSegue" {
//        let vc = segue.destination as! AuthorisationVC
//        
//        
//    }

//}



