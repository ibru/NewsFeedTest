//
//  CollectionCell.swift
//  News Feed Test
//
//  Created by Jiri Urbasek on 23/04/15.
//  Copyright (c) 2015 Jiri Urbasek. All rights reserved.
//

import UIKit

protocol CollectionCellDelegate {
    func cell(cell: UICollectionViewCell, didChangeExpandColapseState wasExpanded: Bool)
}


class CollectionCell1: UICollectionViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyTextView: UITextView!
    
    @IBOutlet weak var headerHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    var delegate: CollectionCellDelegate?
    
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        
        setTranslatesAutoresizingMaskIntoConstraints(false)
        contentView.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        heightConstraint.constant = 0
    }
    
    func configure(cellData: Model.CellData) {
        titleLabel.text = cellData.title
        bodyTextView.text = cellData.message
        
        headerHeightConstraint.constant = cellData.hasHeader ? 25 : 2
    }
    
    override func preferredLayoutAttributesFittingAttributes(layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes! {
        var attributes = super.preferredLayoutAttributesFittingAttributes(layoutAttributes)
        
        attributes.size.width = UIScreen.mainScreen().bounds.width
        //attributes.size.height = 300
        
        return attributes
    }
    
    @IBAction func buttonTouched(sender: AnyObject) {
        
        let height = heightConstraint.constant
        var wasExpanded = false
        
        if height == 0 {
            heightConstraint.constant = 50
            wasExpanded = true
        }
        else {
            heightConstraint.constant = 0
        }
        
        setNeedsUpdateConstraints()
        
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.layoutIfNeeded()
        })
        
        delegate?.cell(self, didChangeExpandColapseState: wasExpanded)
    }

}
