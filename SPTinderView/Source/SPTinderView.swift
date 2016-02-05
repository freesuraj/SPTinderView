//
//  SPTinderView.swift
//  SPTinderView
//
//  Created by Suraj Pathak on 3/2/16.
//  Copyright © 2016 Suraj Pathak. All rights reserved.
//

import UIKit


/// Protocol that feeds the necessary data for SPTinderView
public protocol SPTinderViewDataSource {
    func numberOfItemsInTinderView(view: SPTinderView) -> Int
    func tinderView(view: SPTinderView, cellAt index: Int) -> SPTinderViewCell?
}

///`SPTinderViewDelegate` tells the object conforming it about the actions about the cells in `SPTinderView`
public protocol SPTinderViewDelegate {
    func tinderView(view: SPTinderView, didMoveCellAt index: Int, towards direction: SPTinderViewCellMovement)
}

/// `SPTinderView` is view that mimics the behavior of shuffling cards of a deck left or right, as seen in the popular dating app *Tinder*.
public class SPTinderView: UIView {
    
    // Cache
    private var caches: [SPCache]?
    
    var dataSource: SPTinderViewDataSource? {
        didSet {
            
        }
    }
    
    var delegate: SPTinderViewDelegate?
    var currentIndex: Int = 0
    private let visibleCount = 3
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setUpFirstSetOfCells()
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func awakeFromNib() {
        setUpFirstSetOfCells()
    }
    
    public override func layoutSubviews() {
        
    }
    
    public func reloadData() {
        
    }
    
    private func setUpFirstSetOfCells() {
        guard let _dataSource = dataSource else { return }
        let count = _dataSource.numberOfItemsInTinderView(self)
        for var index = currentIndex; index < min(visibleCount, count - index); index++ {
            if let cell = _dataSource.tinderView(self, cellAt: index) {
                self.insertSubview(cell, atIndex: 0)
                cell.center = positionForCellAtIndex(index)
            }
        }
    }
    
    private func positionForCellAtIndex(index: Int) -> CGPoint {
        var _center = center
        _center.y = center.y + CGFloat((index - currentIndex) * 2)
        
        return _center
    }
    
    private func animateCellReposition() {
        
    }
    
    private func animateRemovalForCell(cell: SPTinderViewCell) {
        UIView.animateWithDuration(0.2, animations: {
            cell.alpha = 0.0
            }, completion: { finished in
                cell.removeFromSuperview()
        })
    }
    
    // MARK: Cache and Recycle
    private func setUpCache() {
//        guard let _dataSource = dataSource else { return }
        print("\(visibleCount)")
    }
    
    private func recycleCell(cell: SPTinderViewCell) {
        
    }
    
    public func registerNib(nib: UINib?, forCellReuseIdentifier identifier: String) {
//        guard let _nib = nib else { return }
//        if let cell = _nib.instantiateWithOwner(self, options: nil).first as? SPTinderViewCell {
////            cache.setObject(cell, forKey: identifier)
//        }
    }
    /**
     Register a new cell class for a given identifier. The cell must conform to `SPTinderViewCell` to be a valid cell. The registered cells will be cached which can be retrieved usign ``dequeueReusableCellWithIdentifier: `` method
     
     @see dequeueReusableCellWithIdentifier:
     
     - parameter cellClass:  Cell class that conforms to `SPTinderViewCell`
     - parameter identifier: identifier that ties the cellClass onto SPTinderView
     */
    public func registerClass(cellClass: AnyClass?, forCellReuseIdentifier identifier: String) {
        if let cell = cellClass where cell is SPTinderViewCell.Type {
//            cache.setObject(cell, forKey: identifier)
        }
    }
    
    /**
    Returns a cached copy of a cell from the cache pool if a cell of given identifier exists. The `SPTinderView` must first register such cell using ``registerClass:forCellReuseIdentifier`` method

    - parameter identifier: identifier to look up

    - returns: `SPTinderViewCell` if cell exists in cache or a nil
     */
    public func dequeueReusableCellWithIdentifier(identifier: String) -> SPTinderViewCell? {
//        return cache.objectForKey(identifier) as? SPTinderViewCell
        return nil
    }
}

class SPCache: NSObject {
    var identifier: String?
    var cachedCells: [CachedCell] = []
    
    convenience init(_identifier: String) {
        self.init()
        identifier = _identifier
    }
    
    func recycleACell(cell: SPTinderViewCell) {
        for cachedCell in cachedCells {
            if let ccell = cachedCell.cell where ccell == cell {
                cachedCell.isFree = true
                break
            }
        }
        let cachedCell = CachedCell()
        cachedCell.cell = cell
        cachedCell.isFree = true
    }
    
    func getAFreeCell() -> SPTinderViewCell? {
        for cachedCell in cachedCells {
            if cachedCell.isFree {
                if let tinderCell = cachedCell.cell {
                    return tinderCell
                }
            }
        }
        return nil
    }
}

class CachedCell {
    var cell: SPTinderViewCell?
    var isFree: Bool = true
}
