//
//  CircleView.swift
//  GitHubiOSAPI
//
//  Created by Melaniia Hulianovych on 4/13/17.
//  Copyright © 2017 Melaniia Hulianovych. All rights reserved.
//

import UIKit


@IBDesignable
class CircleView: UIView {

    var color: UIColor?
  
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        color = backgroundColor!
        let path = UIBezierPath(ovalIn: rect)
        UIColor.blue.setFill()
        path.fill()
        path.close()
    }
 

}
extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
}
