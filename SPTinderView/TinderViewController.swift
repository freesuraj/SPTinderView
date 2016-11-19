//
//  TinderViewController.swift
//  SPTinderView
//
//  Created by Suraj Pathak on 10/2/16.
//  Copyright © 2016 Suraj Pathak. All rights reserved.
//

import UIKit

class TinderViewController: UIViewController {
    let cellIdentifier = "MyCustomTinderCell"
    @IBOutlet var tinderView: SPTinderView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tinderView.frame = self.view.frame
        tinderView.registerNib(UINib(nibName: "MyCustomTinderCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
        tinderView.dataSource = self
        tinderView.delegate = self
        tinderView.backgroundColor = UIColor.white
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension TinderViewController: SPTinderViewDataSource, SPTinderViewDelegate {
    func numberOfItemsInTinderView(_ view: SPTinderView) -> Int {
        return 100
    }
    
    func tinderView(_ view: SPTinderView, cellAt index: Int) -> SPTinderViewCell? {
        if let cell = tinderView.dequeueReusableCellWithIdentifier(cellIdentifier) as? MyCustomTinderCell {
            cell.imageView.image = TinderModel.randomImage()
            cell.titleLabel.text = "Model No: \(index+1)"
            return cell
        }
        return nil
    }
    
    func tinderView(_ view: SPTinderView, didMoveCellAt index: Int, towards direction: SPTinderViewCellMovement) {
        print("\(direction)")
    }
}
