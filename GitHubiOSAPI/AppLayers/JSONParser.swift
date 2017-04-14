//
//  JSONParser.swift
//  GitHubiOSAPI
//
//  Created by Melaniia Hulianovych on 4/13/17.
//  Copyright © 2017 Melaniia Hulianovych. All rights reserved.
//

import Foundation
import UIKit

class JSONParser {
    
    func parseUserInfo(withdata data: NSDictionary) -> User {
        let user = User()
        if let name = data["name"] {
            user.name = name as! String
        }
        if let login = data["login"] {
            user.login = login as! String
        }
        if let avatarURL = data["avatar_url"] {
            user.avatarURL = avatarURL as! String
        }
        if let created = data["created_at"] {
            user.created = created as! String
        }
        if let followers = data["followers"] {
            user.followers = followers as! Int
        }
        if let following = data["following"] {
            user.following = following as! Int
        }
        if let publicRepo = data["public_repos"] {
            user.publicRepo = publicRepo as! Int
        }
        return user
    }
    
    func parseRepositories(fromArray array:NSArray) -> [Repository] {
        
        var repositories = [Repository]()
        for dic in array {
            
            let repo = parseRepo(withDict: dic as! NSDictionary)
            DataSource.shared.user.starsCount += repo.starsCount
            repositories.append(repo)
        }
        return repositories
    }
    
    func parseRepo(withDict dict: NSDictionary) -> Repository {
        let repo = Repository()
        if let name = dict["name"] {
            repo.repoName = name as! String
        }
        if let language = dict["language"] {
            repo.language = language as! String
        }
        if let id = dict["id"] {
            repo.id = id as! Int
        }
        if let forkedFrom = dict["fork"] {
            repo.forkedFrom = forkedFrom as! Bool
        }
        if let forks = dict["forks"] {
            repo.forks = forks as! Int
        }
        if let description = dict["description"] as? String {
            repo.description = description
        }
        if let forks = dict["forks_count"] {
            repo.forks = forks as! Int
        }
        if let watchers = dict["watchers_count"] {
            repo.watchers = watchers as! Int
        }
        if let starsCount = dict["stargazers_count"] {
            repo.starsCount = starsCount as! Int
        }
        if let updated = dict["updated_at"] as? String {
            repo.lastUpdate = df.date(from: updated)
        }
        return repo
    }
    
    func parseAuthor(fromDic dic:NSDictionary, intoCommit commit:Commit) -> Commit {
        if let committer = dic["committer"] {
            
            if let name = (committer as! NSDictionary)["name"] {
                commit.author = name as! String
            }
            if let date = (committer as! NSDictionary)["date"] as? String {
                commit.cratedDate = df.date(from: date)!
            }
        }
        if let message = dic["message"] {
            commit.message = message as! String
        }
        return commit
    }
    
    func parseCommits(fromArray array: NSArray) ->[Commit] {
        var commits = [Commit]()
        for item in array {
            let commit = Commit()
            if let comAv = (item as! NSDictionary)["commiter"] as? NSDictionary{
                if let avatar = comAv["avatar_url"] as? String {
                    commit.authorAvatar = avatar
                }
            }
            if let com = (item as! NSDictionary)["commit"] {
                commits.append(parseAuthor(fromDic: com as! NSDictionary, intoCommit: commit))
            }
            
            
        }
        return commits
    }
    
    
    
}

class User {
    
    var name = ""
    var login = ""
    var created: String!
    var avatarURL = ""
    var followers: Int = 0
    var following: Int = 0
    var publicRepo = 0
    var starsCount = 0
}

class Repository {
    
    var repoName: String = ""
    var language: String = ""
    var id: Int!
    var forkedFrom = false
    var forks = 0
    var description = ""
    var watchers = 0
    var starsCount = 0
    var lastUpdate: Date!
    var commits = [Commit]()
}

class Commit {
    var author = ""
    var authorAvatar = ""
    var cratedDate = Date()
    var message = ""
    var imageForAvatar: UIImage?
    
}

let df : DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
    return formatter
}()
