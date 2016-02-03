//
//  SPTinderViewCell.swift
//  SPTinderView
//
//  Created by Suraj Pathak on 3/2/16.
//  Copyright © 2016 Suraj Pathak. All rights reserved.
//

import UIKit

/**
 *  The SPTinderViewCell defines the attributes and behavior of the cells that appear in SPTinderView objects. This class includes properties and methods for setting and managing cell content and background.
 */

@IBDesignable
public class SPTinderViewCell: UIView, UIGestureRecognizerDelegate {
    @IBInspectable var reuseIdentifier: String?
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
                self.layer.cornerRadius = cornerRadius
        }
    }
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    @IBInspectable var borderColor: UIColor? {
        didSet {
            layer.borderColor = borderColor?.CGColor
        }
    }
    
    var touchView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
    
    convenience init(frame: CGRect, reuseIdentifier: String?) {
        self.init(frame: frame)
        self.reuseIdentifier = reuseIdentifier
    }
    
    public override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        guard let touch = touches.first else { return }
        touchView.backgroundColor = UIColor.orangeColor()
        touchView.layer.cornerRadius = 5
        touchView.center = touch.locationInView(self)
        self.addSubview(touchView)
    }
    
    public override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first {
            let prevLoc = touch.previousLocationInView(self)
            let thisLoc = touch.locationInView(self)
            
            let deltaX = thisLoc.x - prevLoc.x
            let deltaY = thisLoc.y - prevLoc.y
            // There's also a little bit of transformation. When the cell is being dragged, it should feel the angle of drag as well (20 degrees?)
            self.transform = CGAffineTransformMakeRotation(CGFloat(M_PI*5/90))
            
            UIView.animateWithDuration(0.00, animations: { () -> Void in
                self.center.x += deltaX
                self.center.y += deltaY
            })
        }
    }
    
    public override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        UIView.animateWithDuration(0.2, delay: 0.1, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.1, options: UIViewAnimationOptions.BeginFromCurrentState, animations: {
                self.center = CGPoint(x: 200, y: 260)
                self.transform = CGAffineTransformIdentity
            }, completion: { finished in
                self.touchView.removeFromSuperview()
        })
    }
    
    public override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        //
    }
    
    public override func touchesEstimatedPropertiesUpdated(touches: Set<NSObject>) {
       //
    }
}

/**
 `SPTinderViewCellMovement` defines the four types of movement when the cell is dragged around.
 
 - None:   When the cell has not moved or not been moved enough to be considered one of the other 4 movements
 - Top:    When the cell has moved towards top
 - Left:   When the cell has moved towards left
 - Bottom: When the cell has moved towards bottom
 - Right:  When the cell has moved towards right
 */
public enum SPTinderViewCellMovement: Int {
    
    case None
    case Top
    case Left
    case Bottom
    case Right
}
