//
//  NibTableViewCell.swift
//  TableViewCellWithAutoLayout
//
//  Copyright (c) 2014 Morten Bøgh
//

import UIKit

class NibTableViewCell: UITableViewCell
{
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyTextView: UITextView!
    
    @IBOutlet weak var headerHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    var controller: TableViewController?
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        
        heightConstraint.constant = 0
    }
    
    func configure(cellData: Model.CellData) {
        titleLabel.text = cellData.title
        bodyTextView.text = cellData.message
        
        headerHeightConstraint.constant = cellData.hasHeader ? 25 : 2
    }
    
    
    @IBAction func buttonTouched(sender: AnyObject) {
        
        let height = heightConstraint.constant
        if height == 0 {
            heightConstraint.constant = 50
        }
        else {
            heightConstraint.constant = 0
        }
        
        setNeedsUpdateConstraints()
        
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.layoutIfNeeded()
        })
        
        controller?.reloadCell(self)
    }
    
}
