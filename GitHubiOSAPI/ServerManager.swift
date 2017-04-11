//
//  ServerManager.swift
//  GitHubiOSAPI
//
//  Created by Melaniia Hulianovych on 4/11/17.
//  Copyright © 2017 Melaniia Hulianovych. All rights reserved.
//

import Foundation

class ServerManager {
    
    var token = GitHubAccessToken()
    var session: URLSession!
    //    var reachability =
    
    static let shared: ServerManager = {
        let instance = ServerManager()
        return instance
    }()
    
    func authorise(withUser user: String, andPassword password: String) {
        token.user = user
        token.password = password
        
        let urlString = URL(string: "\(Constants.ServerName)/\(Constants.Client_ID)/")
        var urlRequest = URLRequest.init(url: urlString!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 30)
        let input = "\(user):\(password)"
        let data = input.data(using: .utf8)?.base64EncodedString()
        urlRequest.setValue("Basic \(String(describing: data))", forHTTPHeaderField: "Authorization")
        urlRequest.httpMethod = "POST"
        
        session = URLSession()
        let task = session.dataTask(with: urlRequest) {
            (data, response, error) -> Void in
            
            print("Task completed")
            if let data = data {
                do {
                    if let jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                    }
                } catch let error as NSError {
                    print(error.localizedDescription)
                }
                
            } else if let error = error {
                print(error.localizedDescription)
            }
            
            
        }
        task.resume()
    }
    
    
    fileprivate struct Constants {
        static let ServerName = "https://github.com/login/oauth/authorize"
        static let LoginID = "client_id"
        static let PasswordID = "client_secret"
        static let Client_ID = "ea5679f04f9686902f10"
        static let Client_Secret = "081545df6579be8f2d37caeff958a5b21e91b6f1"
    }
    
}

class GitHubAccessToken {
    
    var user: String!
    var password: String!
    var accToken: String?
}
