//
//  ViewController.swift
//  SPTinderView
//
//  Created by Suraj Pathak on 3/2/16.
//  Copyright © 2016 Suraj Pathak. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var tinderCell: SPTinderViewCell!
    @IBOutlet var statusLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tinderCell.onCellDidMove = { movement in
            switch (movement) {
            case .Top:
                self.tinderCell.backgroundColor = UIColor.redColor()
            case .Bottom:
                self.tinderCell.backgroundColor = UIColor.magentaColor()
            case .Left:
                self.tinderCell.backgroundColor = UIColor.greenColor()
            case .Right:
                self.tinderCell.backgroundColor = UIColor.blueColor()
            default:
                self.tinderCell.backgroundColor = UIColor.purpleColor()
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

