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
    var authCode: String!

    //    var reachability =
    
    static let shared: ServerManager = {
        let instance = ServerManager()
    
        return instance
    }()
    

    
    func getAccessToken() {
        let urlString = URL(string: "\(Constants.TokenUrl)")
        var urlRequest = URLRequest.init(url: urlString!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 30)
        let input = "client_id:\(Constants.Client_ID),client_secret:\(Constants.Client_Secret),code:\(authCode)"
        let data = String(describing: input.data(using: .utf8)?.base64EncodedString())
        urlRequest.addValue("Basic \(data)", forHTTPHeaderField: "Authorization")
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("application/x-www-form-urlencoded charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        session = URLSession(configuration: .default)
        let task = session.dataTask(with: urlRequest) {
            (data, response, error) -> Void in
            
            print("Task completed")
            if let data = data {
                do {
                    if let returnData = String(data: data, encoding: .utf8) {
                        print(returnData)
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

    
    func authorise(withUser user: String, andPassword password: String) {
        token.user = user
        token.password = password
        
        let urlString = URL(string: "\(Constants.ServerName)/:\(Constants.Client_ID)")
        var urlRequest = URLRequest.init(url: urlString!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 30)
        let input = "client_id:\(Constants.Client_ID),client_secret:\(Constants.Client_Secret)"
        let data = String(describing: input.data(using: .utf8)?.base64EncodedString())
        urlRequest.setValue("Basic \(data)", forHTTPHeaderField: "Authorization")
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("application/x-www-form-urlencoded charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        session = URLSession(configuration: .default)
        let task = session.dataTask(with: urlRequest) {
            (data, response, error) -> Void in
            
            print("Task completed")
            if let data = data {
                do {
                    if let returnData = String(data: data, encoding: .utf8) {
                        print(returnData)
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
        static let ServerName = "https://github.com/login/oauth/authorize/"
        static let TokenUrl = "https://github.com/login/oauth/access_token/"
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
