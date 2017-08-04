//
//  ViewController.swift
//  SPTinderView
//
//  Created by Suraj Pathak on 3/2/16.
//  Copyright © 2016 Suraj Pathak. All rights reserved.
//

import UIKit


class MyTinderCell: SPTinderViewCell {
    let titleLabel: UILabel = UILabel(frame: CGRect.zero)
    let imageView: UIImageView = UIImageView(frame: CGRect.zero)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    required init(reuseIdentifier: String) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: 300, height: 400))
        self.backgroundColor = UIColor.getRandomColor()
        titleLabel.frame = CGRect(x: 0, y: self.frame.height - 50, width: self.frame.width, height: 50)
        imageView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height - 50)
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        titleLabel.textAlignment = .center
        titleLabel.backgroundColor = UIColor.green
        self.addSubview(imageView)
        self.addSubview(titleLabel)
        self.cornerRadius = 6.0
    }
}

class ViewController: UIViewController {
    @IBOutlet var tinderView: SPTinderView!
    let cellIdentifier = "MyTinderCell"
    var cellCount = 5

    override func viewDidLoad() {
        super.viewDidLoad()
        tinderView.frame = self.view.frame
        tinderView.registerClass(MyTinderCell.self, forCellReuseIdentifier: cellIdentifier)
        tinderView.dataSource = self
        tinderView.delegate = self
        tinderView.backgroundColor = UIColor.white
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "RELOAD", style: .plain, target: self, action: #selector(ViewController.onReload))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func onReload() {
        cellCount += 1
        tinderView.reloadData()
    }
}

extension ViewController: SPTinderViewDataSource, SPTinderViewDelegate {
    func tinderView(_ view: SPTinderView, didSelectCellAt index: Int) {
        title = "Did select at \(index)"
    }

    func numberOfItemsInTinderView(_ view: SPTinderView) -> Int {
        return cellCount
    }
    
    func tinderView(_ view: SPTinderView, cellAt index: Int) -> SPTinderViewCell? {
        if let cell = tinderView.dequeueReusableCellWithIdentifier(cellIdentifier) as? MyTinderCell {
            cell.titleLabel.text = "Model No: \(index+1)"
            cell.imageView.image = TinderModel.randomImage()
            return cell
        }
        return nil
    }
    
    func tinderView(_ view: SPTinderView, didMoveCellAt index: Int, towards direction: SPTinderViewCellMovement) {
        print("\(direction)")
    }
}
