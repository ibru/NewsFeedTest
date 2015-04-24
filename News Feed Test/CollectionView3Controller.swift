//
//  CollectionViewController.swift
//  News Feed Test
//
//  Created by Jiri Urbasek on 23/04/15.
//  Copyright (c) 2015 Jiri Urbasek. All rights reserved.
//

import UIKit

let reuseIdentifier = "Cell"

class CollectionView3Controller: UICollectionViewController, CollectionCellDelegate, UICollectionViewDelegateFlowLayout {

    private let reuseIdentifier = "Collection Cell"
    private var offscreenCells = [String: UICollectionViewCell]()
    
    var model = Model()
    
    var expandedPaths = [NSIndexPath]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView!.registerNib(UINib(nibName: "CollectionCell2", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        
        //(collectionView!.collectionViewLayout as! UICollectionViewFlowLayout).estimatedItemSize = CGSize(width: collectionView!.frame.width, height: 300)
        (collectionView!.collectionViewLayout as! UICollectionViewFlowLayout).headerReferenceSize = CGSize(width: collectionView!.frame.width, height: 150)
        
        model.appendData(20)
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
            
            model.appendData(newDataCount)
            
            for idx in 1...newDataCount {
                indexPaths.append(NSIndexPath(forRow: lastIndex + idx, inSection: indexPath.section))
            }
            collectionView.insertItemsAtIndexPaths(indexPaths)
        }
    }
    
    // MARK: UICollectionViewDelegateFlowLayout
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        println("sizeForItemAtIndexPath called")
        
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
        
        // Cell's size is determined in nib file, need to set it's width (in this case), and inside, use this cell's width to set label's preferredMaxLayoutWidth, thus, height can be determined, this size will be returned for real cell initialization
        cell!.bounds = CGRectMake(0, 0, targetWidth, cell!.bounds.height)
        cell!.contentView.bounds = cell!.bounds
        
        // Layout subviews, this will let labels on this cell to set preferredMaxLayoutWidth
        cell!.setNeedsLayout()
        cell!.layoutIfNeeded()
        
        var size = cell!.contentView.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize)
        // Still need to force the width, since width can be smalled due to break mode of labels
        size.width = targetWidth
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
            collectionView?.performBatchUpdates(nil, completion: nil)
        }
        else {
            println("not found")
        }
    }
}
