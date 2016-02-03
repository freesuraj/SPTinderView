//
//  SPTinderView.swift
//  SPTinderView
//
//  Created by Suraj Pathak on 3/2/16.
//  Copyright © 2016 Suraj Pathak. All rights reserved.
//

import UIKit

/**
 *  Protocol that feeds the necessary data for SPTinderView
 */
public protocol SPTinderViewDataSource {
    func numberOfVisibleCellsInTinderView(view: SPTinderView) -> Int
    func tinderView(view: SPTinderView, cellAtIndex: Int) -> SPTinderViewCell?
}

/**
 *  `SPTinderViewDelegate` tells the object conforming it about the actions about the cells in `SPTinderView`
 */
public protocol SPTinderViewDelegate {
    func tinderView(view: SPTinderView, didMoveCellAtIndex: Int, towards: SPTinderViewCellMovement)
}

/// `SPTinderView` is view that mimics the behavior of shuffling cards of a deck left or right, as seen in the popular dating app *Tinder*.
public class SPTinderView: UIView {
    
    var topCell: SPTinderViewCell?
    public func dequeueReusableCellWithIdentifier(identifier: String) -> SPTinderViewCell? {
        return nil
    }

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
