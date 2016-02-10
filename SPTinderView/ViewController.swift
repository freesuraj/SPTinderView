//
//  ViewController.swift
//  SPTinderView
//
//  Created by Suraj Pathak on 3/2/16.
//  Copyright © 2016 Suraj Pathak. All rights reserved.
//

import UIKit


class MyTinderCell: SPTinderViewCell {
    let titleLabel: UILabel = UILabel(frame: CGRectZero)
    let imageView: UIImageView = UIImageView(frame: CGRectZero)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    required init(reuseIdentifier: String) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.frame = CGRect(origin: CGPointZero, size: CGSize(width: 300, height: 400))
        self.backgroundColor = UIColor.getRandomColor()
        titleLabel.frame = CGRectMake(0, self.frame.height - 50, self.frame.width, 50)
        imageView.frame = CGRectMake(0, 0, self.frame.width, self.frame.height - 50)
        imageView.clipsToBounds = true
        imageView.contentMode = .ScaleAspectFill
        titleLabel.textAlignment = .Center
        titleLabel.backgroundColor = UIColor.greenColor()
        self.addSubview(imageView)
        self.addSubview(titleLabel)
        self.cornerRadius = 6.0
    }
}

class ViewController: UIViewController {
    @IBOutlet var tinderView: SPTinderView!
    let cellIdentifier = "MyTinderCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        tinderView.frame = self.view.frame
        tinderView.registerClass(MyTinderCell.self, forCellReuseIdentifier: cellIdentifier)
        tinderView.dataSource = self
        tinderView.delegate = self
        tinderView.backgroundColor = UIColor.whiteColor()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension ViewController: SPTinderViewDataSource, SPTinderViewDelegate {
    func numberOfItemsInTinderView(view: SPTinderView) -> Int {
        return 20
    }
    
    func tinderView(view: SPTinderView, cellAt index: Int) -> SPTinderViewCell? {
        if let cell = tinderView.dequeueReusableCellWithIdentifier(cellIdentifier) as? MyTinderCell {
            cell.titleLabel.text = "Model No: \(index+1)"
            cell.imageView.image = TinderModel.randomImage()
            return cell
        }
        return nil
    }
    
    func tinderView(view: SPTinderView, didMoveCellAt index: Int, towards direction: SPTinderViewCellMovement) {
        print("\(direction)")
    }
}
