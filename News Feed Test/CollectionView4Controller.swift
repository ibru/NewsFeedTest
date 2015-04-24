//
//  CollectionView4Controller.swift
//  News Feed Test
//
//  Created by Jiri Urbasek on 23/04/15.
//  Copyright (c) 2015 Jiri Urbasek. All rights reserved.
//

import UIKit

class CollectionView4Controller: UICollectionViewController, CollectionCellDelegate, UICollectionViewDelegateFlowLayout {
    
    private let reuseIdentifier = "Collection Cell"
    private var offscreenCells = [String: UICollectionViewCell]()
    
    var model = Model()
    
    var expandedPaths = [NSIndexPath]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView!.registerNib(UINib(nibName: "CollectionCell2", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        
        //(collectionView!.collectionViewLayout as! UICollectionViewFlowLayout).estimatedItemSize = CGSize(width: collectionView!.frame.width, height: 300)
        (collectionView!.collectionViewLayout as! UICollectionViewFlowLayout).headerReferenceSize = CGSize(width: collectionView!.frame.width, height: 150)
        
        let newDataCount = 20
        var indexPaths = [NSIndexPath]()
        
        model.appendData(newDataCount)
        
        for idx in 0..<newDataCount {
            indexPaths.append(NSIndexPath(forRow: idx, inSection: 0))
        }
        cacheSizesForAppendedIndexPaths(indexPaths)
        
        collectionView!.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: UICollectionViewDataSource
    
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model.data.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! CollectionCell2
        
        cell.configure(model.data[indexPath.row])
        cell.delegate = self
        cell.heightConstraint.constant = (find(expandedPaths, indexPath) != nil) ? 50 : 0
        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.row == model.data.count - 1 {
            
            let newDataCount = 20
            let lastIndex = indexPath.row
            var indexPaths = [NSIndexPath]()
            
            let middle = newDataCount / 2
            let rest = newDataCount - middle
            var firstHalf = [NSIndexPath]()
            var secondHalf = [NSIndexPath]()
            
            for idx in 1...newDataCount {
                if idx <= middle {
                    firstHalf.append(NSIndexPath(forRow: lastIndex + idx, inSection: indexPath.section))
                }
                else {
                    secondHalf.append(NSIndexPath(forRow: lastIndex + idx, inSection: indexPath.section))
                }
            }
            
            self.model.appendData(middle)
            self.cacheSizesForAppendedIndexPaths(firstHalf)
            self.collectionView?.insertItemsAtIndexPaths(firstHalf)
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.4 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), {
                self.model.appendData(rest)
                self.cacheSizesForAppendedIndexPaths(secondHalf)
                self.collectionView?.insertItemsAtIndexPaths(secondHalf)
            })
        }
    }
    
    // MARK: UICollectionViewDelegateFlowLayout
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        let size = cachedItemSizes[indexPath.row]
        return size
    }
    
    // MARK: CollectionCellDelegate
    
    func cell(cell: UICollectionViewCell, didChangeExpandColapseState wasExpanded: Bool) {
        if let indexPath = collectionView?.indexPathForCell(cell) {
            if let index = find(expandedPaths, indexPath) {
                expandedPaths.removeAtIndex(index)
            }
            else {
                expandedPaths.append(indexPath)
            }
            cachedItemSizes[indexPath.row] = sizeOfItemIn(collectionView!, layout: collectionView!.collectionViewLayout, atIndexPath: indexPath)
            collectionView?.performBatchUpdates(nil, completion: nil)
        }
        else {
            println("not found")
        }
    }
    
    // MARK: Private
    
    func sizeOfItemIn(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, atIndexPath indexPath: NSIndexPath) -> CGSize {
        
        println("sizeOfItemIn called")
        
        let targetWidth: CGFloat = collectionView.bounds.width
        
        // Use fake cell to calculate height
        var cell: CollectionCell2? = self.offscreenCells[reuseIdentifier] as? CollectionCell2
        if cell == nil {
            cell = NSBundle.mainBundle().loadNibNamed("CollectionCell2", owner: self, options: nil)[0] as? CollectionCell2
            offscreenCells[reuseIdentifier] = cell
        }
        
        // Config cell and let system determine size
        cell!.configure(model.data[indexPath.row])
        cell!.heightConstraint.constant = (find(expandedPaths, indexPath) != nil) ? 50 : 0
        
        cell!.bounds = CGRectMake(0, 0, targetWidth, 9999)
        cell!.contentView.bounds = cell!.bounds
        
        var size = cell!.contentView.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize)
        
        // Still need to force the width, since width can be smalled due to break mode of labels
        size.width = targetWidth
        
        return size
    }
    
    private var cachedItemSizes = [CGSize]()
    
    func cacheSizesForAppendedIndexPaths(indexPaths: [NSIndexPath]) {
        for indexPath in indexPaths {
            let size = sizeOfItemIn(collectionView!, layout: collectionView!.collectionViewLayout, atIndexPath: indexPath)
            cachedItemSizes.append(size)
        }
    }
}