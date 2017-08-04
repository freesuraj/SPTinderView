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
    func numberOfItemsInTinderView(_ view: SPTinderView) -> Int
    func tinderView(_ view: SPTinderView, cellAt index: Int) -> SPTinderViewCell?
}

///`SPTinderViewDelegate` tells the object conforming it about the actions about the cells in `SPTinderView`
public protocol SPTinderViewDelegate {
    func tinderView(_ view: SPTinderView, didMoveCellAt index: Int, towards direction: SPTinderViewCellMovement)
    func tinderView(_ view: SPTinderView, didSelectCellAt index: Int)
}

/// `SPTinderView` is view that mimics the behavior of shuffling cards of a deck left or right, as seen in the popular dating app *Tinder*.
public class SPTinderView: UIView {
    
    // Cache
    fileprivate var caches: [SPCache] = []
    
    public var dataSource: SPTinderViewDataSource? {
        didSet {
            self.reloadData()
        }
    }
    
    public var delegate: SPTinderViewDelegate?
    public var currentIndex: Int = 0
    fileprivate let visibleCount = 3
    fileprivate var numberOfCells = 0
    
    // MARK: Initialization
    public override init(frame: CGRect) {
        super.init(frame: frame)
        reloadData()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        reloadData()
    }
    
    public override func awakeFromNib() {
        reloadData()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    fileprivate func setUpFirstSetOfCells() {
        guard let _dataSource = dataSource else { return }
        numberOfCells = _dataSource.numberOfItemsInTinderView(self)
        for index in currentIndex ..< min(visibleCount, numberOfCells - currentIndex) {
            insertCell(at: index)
        }
        adjustVisibleCellPosition()
    }
    
    fileprivate func cleanTinderView() {
        for cell in visibleCells() {
            cell.removeFromSuperview()
            recycleACell(cell)
        }
        currentIndex = 0
    }
    
    fileprivate func visibleCells() -> [SPTinderViewCell] {
        var cells: [SPTinderViewCell] = []
        for aView in self.subviews {
            if let cell = aView as? SPTinderViewCell {
                cells.append(cell)
            }
        }
        return cells
    }
    
    fileprivate func insertCell(at index: Int) {
        guard let _dataSource = dataSource , index < numberOfCells else { return }
        if let cell = _dataSource.tinderView(self, cellAt: index) {
            cell.onCellDidMove = { [weak self] direction in
                guard let weakSelf = self else { return }
                if direction == .tapped {
                    weakSelf.delegate?.tinderView(weakSelf, didSelectCellAt: index)
                }
                else if direction != .none {
                    weakSelf.animateRemovalForCell(cell, towards: direction, completion:  {
                        weakSelf.delegate?.tinderView(weakSelf, didMoveCellAt: index, towards: direction)
                    })
                }
            }
            self.insertSubview(cell, at: 0)
            self.sendSubview(toBack: cell)
            cell.center = self.center
        }
    }
    
    fileprivate func adjustVisibleCellPosition() {        
        UIView.animate(withDuration: 0.3, animations: {
            for (position, cell) in self.visibleCells().enumerated() {
                cell.center.y = self.center.y - CGFloat(position * 5)
            }
        })
    }
    
    fileprivate func animateRemovalForCell(_ cell: SPTinderViewCell, towards direction: SPTinderViewCellMovement, completion:@escaping ()->()) {
        var newPosition = CGPoint.zero
        switch direction {
        case .none, .tapped: return
        case .left: newPosition = CGPoint(x: -2*cell.frame.width, y: cell.center.y)
        case .right: newPosition = CGPoint(x: 2*cell.frame.width, y: cell.center.y)
        case .top: newPosition = CGPoint(x: cell.center.x, y: -2*cell.frame.height)
        case .bottom: newPosition = CGPoint(x: cell.center.x, y: 2*cell.frame.height)
        }
        UIView.animate(withDuration: 0.3, animations: {
            cell.center = newPosition
            }, completion: { finished in
                cell.removeFromSuperview()
                self.recycleACell(cell)
                self.insertCell(at: self.currentIndex + self.visibleCount)
                self.currentIndex += 1
                self.adjustVisibleCellPosition()
                completion()
        })
    }
    
    // MARK: Public Method
    /**
    Register the Cell class from the provided nib file. The registered cells will be cached which can be retrieved usign ``dequeueReusableCellWithIdentifier: `` method
    
    @see dequeueReusableCellWithIdentifier:
    
    - parameter nib:        UINib of the cell class of type `SPTinderViewCell`
    - parameter identifier: Identifier that ties the cellClass onto SPTinderView
    */
    public func registerNib(_ nib: UINib?, forCellReuseIdentifier identifier: String) {
        guard let _nib = nib else { return }
        for _ in 0...visibleCount {
            if let cell = _nib.instantiate(withOwner: nil, options: nil).first as? SPTinderViewCell {
                for aView in cell.subviews {
                    aView.translatesAutoresizingMaskIntoConstraints = false
                }
                registerACell(cell, forIdentifier: identifier)
            }
        }
    }
    /**
     Register a new cell class for a given identifier. The cell must conform to `SPTinderViewCell` to be a valid cell. The registered cells will be cached which can be retrieved usign ``dequeueReusableCellWithIdentifier: `` method
     
     @see dequeueReusableCellWithIdentifier:
     
     - parameter cellClass:  Cell class that conforms to `SPTinderViewCell`
     - parameter identifier: Identifier that ties the cellClass onto SPTinderView
     */
    public func registerClass(_ cellClass: AnyClass?, forCellReuseIdentifier identifier: String) {
        if let cell = cellClass as? SPTinderViewCell.Type {
            for _ in 0...visibleCount {
                registerACell(cell.init(reuseIdentifier: identifier), forIdentifier: identifier)
            }
        }
    }
    
    /**
    Returns a cached copy of a cell from the cache pool if a cell of given identifier exists. The `SPTinderView` must first register such cell using ``registerClass:forCellReuseIdentifier`` method

    - parameter identifier: identifier to look up

    - returns: `SPTinderViewCell` if cell exists in cache or a nil
     */
    public func dequeueReusableCellWithIdentifier(_ identifier: String) -> SPTinderViewCell? {
        let cell = self.getAFreeCellForIdentifier(identifier)
        return cell
    }
    
    public func reloadData() {
        cleanTinderView()
        setUpFirstSetOfCells()
    }
    
    // MARK: Cache Management
    fileprivate func getAFreeCellForIdentifier(_ identifier: String) -> SPTinderViewCell? {
        for cache in caches {
            if cache.identifier == identifier {
                return cache.getAFreeCell()
            }
        }
        return nil
    }
    
    fileprivate func registerACell(_ cell: SPTinderViewCell, forIdentifier identifier: String) {
        for cache in caches {
            if cache.identifier == identifier {
                cache.recycleACell(cell)
                return
            }
        }
        let cache = SPCache(_identifier: identifier)
        cache.recycleACell(cell)
        caches.append(cache)
    }
    
    fileprivate func recycleACell(_ cell: SPTinderViewCell) {
        for cache in caches {
            if cache.identifier == cell.reuseIdentifier {
                cache.recycleACell(cell)
                return
            }
        }
    }
}

/// SPCache class manages the cell cache for SPTinderView
private class SPCache {
    var identifier: String
    var cachedCells: [CachedCell] = []
    
    required init(_identifier: String) {
        identifier = _identifier
    }
    
    func recycleACell(_ cell: SPTinderViewCell) {
        for cachedCell in cachedCells {
            if cachedCell.cell == cell {
                cachedCell.isFree = true
                break
            }
        }
        let cachedCell = CachedCell(_cell: cell)
        cachedCells.append(cachedCell)
    }
    
    func getAFreeCell() -> SPTinderViewCell? {
        for cachedCell in cachedCells {
            if cachedCell.isFree {
                cachedCell.isFree = false
                cachedCell.cell.alpha = 1.0
                cachedCell.cell.transform = CGAffineTransform.identity
                return cachedCell.cell
            }
        }
        return nil
    }
}

private class CachedCell {
    var cell: SPTinderViewCell
    var isFree: Bool = true
    
    required init(_cell: SPTinderViewCell) {
        cell = _cell
        isFree = true
    }
}
