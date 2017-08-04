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
    
    var cellMovement: SPTinderViewCellMovement = .none
    
    typealias cellMovementChange = (SPTinderViewCellMovement) -> ()
    var onCellDidMove: cellMovementChange?
    
    fileprivate var originalCenter = CGPoint(x: 0, y: 0)
    fileprivate var scaleToRemoveCell: CGFloat = 0.3
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
    
    fileprivate func setupLayerAttributes() {
        self.layer.shouldRasterize = false
        self.layer.borderWidth = 2.0
        self.layer.borderColor = UIColor.clear.cgColor
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
        self.layer.shadowOpacity = 0.5
        self.layer.masksToBounds = false
    }
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let _ = touches.first else { return }
        originalCenter = self.center
    }
    
    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let prevLoc = touch.previousLocation(in: self)
            let thisLoc = touch.location(in: self)
            
            let deltaX = thisLoc.x - prevLoc.x
            let deltaY = thisLoc.y - prevLoc.y
            // There's also a little bit of transformation. When the cell is being dragged, it should feel the angle of drag as well
            let xDrift = self.center.x + deltaX - originalCenter.x
            let rotationAngle = xDrift * -0.05 * CGFloat(Double.pi / 90)
            // Note: Must set the animation option to `AllowUserInteraction` to prevent the main thread being blocked while animation is ongoin
            let rotatedTransfer = CGAffineTransform(rotationAngle: rotationAngle)
            UIView.animate(withDuration: 0.0, delay: 0.0, options: [.allowUserInteraction], animations: {
                self.transform = rotatedTransfer
                self.center.x += deltaX
                self.center.y += deltaY
                }, completion: { finished in
                    
            })
        }
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let xDrift = self.center.x - originalCenter.x
        let yDrift = self.center.y - originalCenter.y
        self.setCellMovementDirectionFromDrift(xDrift, yDrift: yDrift)
    }
    
    public override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIView.animate(withDuration: 0.2, delay: 0.1, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.1, options: [.allowUserInteraction], animations: {
            self.center = self.originalCenter
            self.transform = CGAffineTransform.identity
            }, completion: { finished in
        })
    }
    
    public override func touchesEstimatedPropertiesUpdated(_ touches: Set<UITouch>) {
       //
    }
    
    func setCellMovementDirectionFromDrift(_ xDrift: CGFloat, yDrift: CGFloat){
        if xDrift == 0, yDrift == 0 {
            onCellDidMove?(.tapped)
            return
        }
        var movement: SPTinderViewCellMovement = .none
        if(xDrift > self.frame.width * scaleToRemoveCell) { movement = .right }
        else if(-xDrift > self.frame.width * scaleToRemoveCell) { movement = .left }
        else if(-yDrift > self.frame.height * scaleToRemoveCell) { movement = .top }
        else if(yDrift > self.frame.height * scaleToRemoveCell) { movement = .bottom }
        else { movement = .none }
        if movement != .none  {
            self.cellMovement = movement
            if let cellMoveBlock = onCellDidMove {
                cellMoveBlock(movement)
            }
        } else {
            UIView.animate(withDuration: 0.5, delay: 0.1, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [.allowUserInteraction], animations: {
                self.center = self.originalCenter
                self.transform = CGAffineTransform.identity
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
    case none
    case top
    case left
    case bottom
    case right
    case tapped
}

