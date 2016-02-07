//
//  MyCustomTinderCell.swift
//  SPTinderView
//
//  Created by Suraj Pathak on 7/2/16.
//  Copyright © 2016 Suraj Pathak. All rights reserved.
//

import UIKit

class MyCustomTinderCell: SPTinderViewCell {
    @IBOutlet var imageView: UIImageView!

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    override func awakeFromNib() {
        imageView.layer.masksToBounds = true
    }

}
