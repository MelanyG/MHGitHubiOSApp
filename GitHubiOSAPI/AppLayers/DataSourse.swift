//
//  DataSourse.swift
//  GitHubiOSAPI
//
//  Created by Melaniia Hulianovych on 4/13/17.
//  Copyright © 2017 Melaniia Hulianovych. All rights reserved.
//

import Foundation

class DataSource {
    var user = User()
    var repositories = [Repository]()
    
    
    static let shared: DataSource = {
        let instance = DataSource()
        
        return instance
    }()
}
