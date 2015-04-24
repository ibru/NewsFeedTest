//
//  CollectionView2Controller.swift
//  News Feed Test
//
//  Created by Jiri Urbasek on 23/04/15.
//  Copyright (c) 2015 Jiri Urbasek. All rights reserved.
//

import UIKit


class CollectionView2Controller: UICollectionViewController, CollectionCellDelegate {

    private let reuseIdentifier = "Collection Cell"
    
    var model = Model()
    
    var expandedPaths = [NSIndexPath]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView!.registerNib(UINib(nibName: "CollectionCell2", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        
        (collectionView!.collectionViewLayout as! UICollectionViewFlowLayout).estimatedItemSize = CGSize(width: collectionView!.frame.width, height: 300)
        (collectionView!.collectionViewLayout as! UICollectionViewFlowLayout).headerReferenceSize = CGSize(width: collectionView!.frame.width, height: 150) // this crashes on iOS version smaller than iOS 8.3
        
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
