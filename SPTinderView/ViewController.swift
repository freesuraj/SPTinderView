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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    required init(reuseIdentifier: String) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.frame = CGRect(origin: CGPointZero, size: CGSize(width: 320, height: 400))
        self.backgroundColor = UIColor.getRandomColor()
        self.borderColor = UIColor.lightGrayColor()
        self.cornerRadius = 6.0
        titleLabel.frame = self.frame
        titleLabel.textAlignment = .Center
        self.addSubview(titleLabel)
        self.borderWidth = 1.0
    }
}

class ViewController: UIViewController {
    @IBOutlet var tinderView: SPTinderView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tinderView.frame = self.view.frame
//        tinderView.registerClass(MyTinderCell.self, forCellReuseIdentifier: "MyTinderCell")
        tinderView.registerNib(UINib(nibName: "MyCustomTinderCell", bundle: nil), forCellReuseIdentifier: "MyCustomTinderCell")
        tinderView.dataSource = self
        tinderView.delegate = self
        print("tv frame size \(self.tinderView.frame), this view: \(self.view.frame)")
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
        if let cell = tinderView.dequeueReusableCellWithIdentifier("MyCustomTinderCell") as? MyCustomTinderCell {
            cell.imageView.image = randomImage()
            return cell
        }
        return nil
    }
    
    func tinderView(view: SPTinderView, didMoveCellAt index: Int, towards direction: SPTinderViewCellMovement) {
        print("\(direction)")
    }
    
    func randomImage() -> UIImage? {
        let number = Int(arc4random_uniform(6) + 1)
        return UIImage(named: "tg\(number).jpg")
    }
}

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

