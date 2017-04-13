//
//  ServerManager.swift
//  GitHubiOSAPI
//
//  Created by Melaniia Hulianovych on 4/11/17.
//  Copyright © 2017 Melaniia Hulianovych. All rights reserved.
//

import Foundation

class ServerManager: NSObject {
    
    var token = GitHubAccessToken()
    var session: URLSession!
    var authCode: String!
    var authToken: String!
    //    var reachability =
    
    static let shared: ServerManager = {
        let instance = ServerManager()
    
        return instance
    }()
    

    
    func getAccessToken() {
        let urlString = URL(string: "\(Constants.TokenUrl)")
        var urlRequest = URLRequest.init(url: urlString!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 30)
        
        var _params: [String : String] = Dictionary()
        _params["client_id"] = Constants.Client_ID
        _params["client_secret"] = Constants.Client_Secret
        _params["code"] = authCode
        
        let client_id = Constants.Client_ID
        let client_secret = Constants.Client_Secret
        let code = authCode
        
        var body = Data()
        
        let boundary = "---------------------------0983745982375409872438752038475287"
        
        let contentType = "multipart/form-data; boundary=\(boundary)"
       urlRequest.addValue(contentType, forHTTPHeaderField:"Content-Type")

        for param in _params {

            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(param.key)\"\r\n\r\n".data(using: .utf8)!)
            body.append("\(_params[param.value])\r\n".data(using: .utf8)!)
        }
        if client_id.characters.count > 0 {
            
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"client_id\"\r\n\r\n".data(using: .utf8)!)
            body.append(client_id.data(using: .utf8)!)
            body.append("\r\n".data(using: .utf8)!)

        }
        if client_secret.characters.count > 0 {
            
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"client_secret\"\r\n\r\n".data(using: .utf8)!)
            body.append(client_secret.data(using: .utf8)!)
            body.append("\r\n".data(using: .utf8)!)
            
        }
        if (code?.characters.count)! > 0 {
       
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"code\"\r\n\r\n".data(using: .utf8)!)
            body.append((code?.data(using: .utf8)!)!)
            body.append("\r\n".data(using: .utf8)!)

        }
        
         body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        urlRequest.httpBody = body

        urlRequest.httpMethod = "POST"
        
        session = URLSession(configuration: .default)
        let task = session.dataTask(with: urlRequest) {
           [weak self](data, response, error) -> Void in

            if let data = data {
                do {
                    if let returnData = String(data: data, encoding: .utf8) {
                        self?.authToken = returnData.components(separatedBy:"=")[1].components(separatedBy:"&").first
                        print(returnData)
                        self?.getAuthentificatedUser()
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

    
    func getAuthentificatedUser() {
        
        let urlString = URL(string: "\(Constants.UserDataUrl)\(authToken!)")
        var urlRequest = URLRequest.init(url: urlString!)

        urlRequest.httpMethod = "GET"
        
        session = URLSession(configuration: .default)
        let task = session.dataTask(with: urlRequest) {
            (data, response, error) -> Void in

            if let data = data {
                do {
                    if let jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {

                        print(jsonResult)
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
        static let UserDataUrl = "https://api.github.com/user?access_token="
        static let Client_ID = "ea5679f04f9686902f10"
        static let Client_Secret = "081545df6579be8f2d37caeff958a5b21e91b6f1"
    }
    
}

class GitHubAccessToken {
    
    var user: String!
    var password: String!
    var accToken: String?
}
