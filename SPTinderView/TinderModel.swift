//
//  TinderModel.swift
//  SPTinderView
//
//  Created by Suraj Pathak on 10/2/16.
//  Copyright © 2016 Suraj Pathak. All rights reserved.
//

import UIKit

// MARK: UIColor
extension UIColor {
    /**
     Returns a random UIColor with full opacity
     */
    static func getRandomColor() -> UIColor {
        
        let randomRed:CGFloat = CGFloat(drand48())
        let randomGreen:CGFloat = CGFloat(drand48())
        let randomBlue:CGFloat = CGFloat(drand48())
        
        return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
    }
}

struct TinderModel {
    static func randomImage() -> UIImage? {
        let number = Int(arc4random_uniform(6) + 1)
        return UIImage(named: "tg\(number).jpg")
    }
}