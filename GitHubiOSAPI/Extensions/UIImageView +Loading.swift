//
//  UIImageView +Loading.swift
//  GitHubiOSAPI
//
//  Created by Melaniia Hulianovych on 4/13/17.
//  Copyright © 2017 Melaniia Hulianovych. All rights reserved.
//

import UIKit

extension UIImageView {
    
    func setImageWithURL(url:String) {
        
        let sessionTask = URLSession.shared
        let request = URLRequest(url: URL(string:url)!)
        sessionTask.dataTask(with: request, completionHandler: { [unowned self] (data: Data?, response: URLResponse?, error: Error?) -> Void in
            if (error == nil) {
                let image: UIImage = UIImage(data: data!)!
                DispatchQueue.main.async {
                    self.image = image
                }
                
            }
            
        }).resume()
    }
    
    func maskDownloadImageView() {
        self.image = self.image?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        self.tintColor = UIColor(colorLiteralRed: 87/255, green: 96/255, blue: 104/255, alpha: 1)

    }
}
