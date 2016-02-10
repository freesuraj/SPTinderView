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
    @IBOutlet var titleLabel: UILabel!
    
    override func awakeFromNib() {
        imageView.clipsToBounds = true
        imageView.contentMode = .ScaleAspectFill
    }

}
