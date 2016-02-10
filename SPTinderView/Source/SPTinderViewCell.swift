//
//  SPTinderViewCell.swift
//  SPTinderView
//
//  Created by Suraj Pathak on 3/2/16.
//  Copyright © 2016 Suraj Pathak. All rights reserved.
//

import UIKit

 /// The SPTinderViewCell defines the attributes and behavior of the cells that appear in SPTinderView objects. This class includes properties and methods for setting and managing cell content and background.

@IBDesignable
public class SPTinderViewCell: UIView, UIGestureRecognizerDelegate {
    @IBInspectable var reuseIdentifier: String?
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    var cellMovement: SPTinderViewCellMovement = .None
    
    typealias cellMovementChange = (SPTinderViewCellMovement) -> ()
    var onCellDidMove: cellMovementChange?
    
    private var originalCenter = CGPoint(x: 0, y: 0)
    private var scaleToRemoveCell: CGFloat = 0.3
    public override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
    }
    
    public required init(reuseIdentifier: String) {
        self.init()
        self.reuseIdentifier = reuseIdentifier
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayerAttributes()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupLayerAttributes()
    }
    
    private func setupLayerAttributes() {
        self.layer.shouldRasterize = true
        self.layer.borderWidth = 2.0
        self.layer.borderColor = UIColor.clearColor().CGColor
        self.layer.shadowColor = UIColor.darkGrayColor().CGColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
        self.layer.shadowOpacity = 0.5
        self.layer.masksToBounds = false
    }
    
    public override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        guard let _ = touches.first else { return }
        originalCenter = self.center
    }
    
    public override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first {
            let prevLoc = touch.previousLocationInView(self)
            let thisLoc = touch.locationInView(self)
            
            let deltaX = thisLoc.x - prevLoc.x
            let deltaY = thisLoc.y - prevLoc.y
            // There's also a little bit of transformation. When the cell is being dragged, it should feel the angle of drag as well
            let xDrift = self.center.x + deltaX - originalCenter.x
            let rotationAngle = xDrift * -0.05 * CGFloat(M_PI / 90)
            // Note: Must set the animation option to `AllowUserInteraction` to prevent the main thread being blocked while animation is ongoin
            let rotatedTransfer = CGAffineTransformMakeRotation(rotationAngle)
            UIView.animateWithDuration(0.0, delay: 0.0, options: [.AllowUserInteraction], animations: {
                self.transform = rotatedTransfer
                self.center.x += deltaX
                self.center.y += deltaY
                }, completion: { finished in
            })
        }
    }
    
    public override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let xDrift = self.center.x - originalCenter.x
        let yDrift = self.center.y - originalCenter.y
        self.setCellMovementDirectionFromDrift(xDrift, yDrift: yDrift)
    }
    
    public override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        UIView.animateWithDuration(0.2, delay: 0.1, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.1, options: [.AllowUserInteraction], animations: {
            self.center = self.originalCenter
            self.transform = CGAffineTransformIdentity
            }, completion: { finished in
        })
    }
    
    public override func touchesEstimatedPropertiesUpdated(touches: Set<NSObject>) {
       //
    }
    
    func setCellMovementDirectionFromDrift(xDrift: CGFloat, yDrift: CGFloat){
        var movement: SPTinderViewCellMovement = .None
        if(xDrift > self.frame.width * scaleToRemoveCell) { movement = .Right }
        else if(-xDrift > self.frame.width * scaleToRemoveCell) { movement = .Left }
        else if(-yDrift > self.frame.height * scaleToRemoveCell) { movement = .Top }
        else if(yDrift > self.frame.height * scaleToRemoveCell) { movement = .Bottom }
        else { movement = .None }
        if movement != .None  {
            self.cellMovement = movement
            if let cellMoveBlock = onCellDidMove {
                cellMoveBlock(movement)
            }
        } else {
            UIView.animateWithDuration(0.5, delay: 0.1, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [.AllowUserInteraction], animations: {
                self.center = self.originalCenter
                self.transform = CGAffineTransformIdentity
                }, completion: nil)
        }
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

