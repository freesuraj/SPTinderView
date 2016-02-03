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
            self.statusLabel.text = "\(movement)"
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

