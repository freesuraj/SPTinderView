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
    private var caches: [SPCache] = []
    
    public var dataSource: SPTinderViewDataSource? {
        didSet {
            self.reloadData()
        }
    }
    
    public var delegate: SPTinderViewDelegate?
    public var currentIndex: Int = 0
    private let visibleCount = 3
    private var numberOfCells = 0
    
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
    
    private func setUpFirstSetOfCells() {
        guard let _dataSource = dataSource else { return }
        numberOfCells = _dataSource.numberOfItemsInTinderView(self)
        for var index = currentIndex; index < min(visibleCount, numberOfCells - index); index++ {
            insertCell(at: index)
        }
        adjustVisibleCellPosition()
    }
    
    private func cleanTinderView() {
        for cell in visibleCells() {
            cell.removeFromSuperview()
            recycleACell(cell)
        }
        currentIndex = 0
    }
    
    private func visibleCells() -> [SPTinderViewCell] {
        var cells: [SPTinderViewCell] = []
        for aView in self.subviews {
            if let cell = aView as? SPTinderViewCell {
                cells.append(cell)
            }
        }
        return cells
    }
    
    private func insertCell(at index: Int) {
        guard let _dataSource = dataSource where index < numberOfCells else { return }
        if let cell = _dataSource.tinderView(self, cellAt: index) {
            cell.onCellDidMove = { direction in
                if direction != .None {
                    self.animateRemovalForCell(cell, towards: direction, completion:  {
                        if let _delegate = self.delegate {
                            _delegate.tinderView(self, didMoveCellAt: index, towards: direction)
                        }
                    })
                }
            }
            self.insertSubview(cell, atIndex: 0)
            self.sendSubviewToBack(cell)
            cell.center = self.center
        }
    }
    
    private func adjustVisibleCellPosition() {        
        UIView.animateWithDuration(0.3, animations: {
            for (position, cell) in self.visibleCells().enumerate() {
                cell.center.y = self.center.y - CGFloat(position * 5)
            }
        })
    }
    
    private func animateRemovalForCell(cell: SPTinderViewCell, towards direction: SPTinderViewCellMovement, completion:()->()) {
        var newPosition = CGPointZero
        switch direction {
        case .None: return
        case .Left: newPosition = CGPoint(x: -2*cell.frame.width, y: cell.center.y)
        case .Right: newPosition = CGPoint(x: 2*cell.frame.width, y: cell.center.y)
        case .Top: newPosition = CGPoint(x: cell.center.x, y: -2*cell.frame.height)
        case .Bottom: newPosition = CGPoint(x: cell.center.x, y: 2*cell.frame.height)
        }
        UIView.animateWithDuration(0.3, animations: {
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
    public func registerNib(nib: UINib?, forCellReuseIdentifier identifier: String) {
        guard let _nib = nib else { return }
        for _ in 0...visibleCount {
            if let cell = _nib.instantiateWithOwner(nil, options: nil).first as? SPTinderViewCell {
                for aView in cell.subviews {
                    aView.translatesAutoresizingMaskIntoConstraints = true
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
    public func registerClass(cellClass: AnyClass?, forCellReuseIdentifier identifier: String) {
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
    public func dequeueReusableCellWithIdentifier(identifier: String) -> SPTinderViewCell? {
        let cell = self.getAFreeCellForIdentifier(identifier)
        return cell
    }
    
    public func reloadData() {
        cleanTinderView()
        setUpFirstSetOfCells()
    }
    
    // MARK: Cache Management
    private func getAFreeCellForIdentifier(identifier: String) -> SPTinderViewCell? {
        for cache in caches {
            if cache.identifier == identifier {
                return cache.getAFreeCell()
            }
        }
        return nil
    }
    
    private func registerACell(cell: SPTinderViewCell, forIdentifier identifier: String) {
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
    
    private func recycleACell(cell: SPTinderViewCell) {
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
    
    func recycleACell(cell: SPTinderViewCell) {
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
                cachedCell.cell.transform = CGAffineTransformIdentity
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
