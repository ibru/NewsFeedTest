# Some observations found in the app

# Table View:
## Interesting parts of the source code
### TableViewController

tableView.rowHeight = UITableViewAutomaticDimension
tableView.estimatedRowHeight = 200.0

//tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic) // crashing the app
tableView.reloadData()


## Good
- looks good at first sight
- performance is sufficient

## Worse
- scroll indicator is jumping a lot

## Bad
- while loading next batch of rows, estimated heights get recomputed and scrolling up gets chopped
- same think happens also when touching Show/Hide button and scrolling up


# Collection View 1
## Interesting parts of the source code
### CollectionView1Controller
(collectionView!.collectionViewLayout as! UICollectionViewFlowLayout).estimatedItemSize = CGSize(width: collectionView!.frame.width, height: 300)

### CollectionCell1
override func preferredLayoutAttributesFittingAttributes(layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes!

## Good

## Worse

## Bad
- text view content is too much into left (see in Xcode: Debug > View Debugging > Capture View Hierarchy)
- collection view does not display all cells
- random gaps between cells
- show/hide feature totally breaks collection view layout


# Collection View 2
## Interesting parts of the source code
### CollectionView2Controller
(collectionView!.collectionViewLayout as! UICollectionViewFlowLayout).headerReferenceSize = CGSize(width: collectionView!.frame.width, height: 150) // this crashes on iOS version smaller than iOS 8.3

### CollectionCell2
fullWidthConstraint.constant = UIScreen.mainScreen().bounds.width - contentView.layoutMargins.left - contentView.layoutMargins.left

(we might use also UILabel’s preferredMaxLayoutWidth and set it in layoutSubviews)

removed preferredLayoutAttributesFittingAttributes

## Good
- items correctly laid out

## Worse
- scroll indicator jumps a lot
- chopped scroll view

## Bad
- collection view does not display all cells
- sometimes last cell is cut off and part of it is below bottom edge of collection view
- random gaps between rows
- show/hide feature totally breaks collection view layout


# Collection View 3
## Interesting parts of the source code
### CollectionView3Controller

removed .estimatedItemSize = ...

func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize


## Good
- rows laid out properly
- scrolling is performance is sufficient, no chopped scrolling or indicator jumping

## Worse

## Bad
- displaying new batch of rows takes too long (because of computing of all row sizes again)
- show/hide feature takes very long (because it again triggers computing of all row sizes again)

tip: count how many times message 'sizeForItemAtIndexPath called’ is printed to console after new batch of rows is loaded or when touching Show/Hide button


# Collection View 4
## Interesting parts of the source code
### CollectionView4Controller

caching computed sizes of cells:
func cacheSizesForAppendedIndexPaths(indexPaths: [NSIndexPath])

we can remove this lines since we dont use preferredMaxLayoutWidth:
cell!.setNeedsLayout()
cell!.layoutIfNeeded()

## Good
- rows laid out properly
- scrolling is performance is sufficient, no chopped scrolling or indicator jumping

## Worse
- if we have very complex cells with complex auto-layout we can still see little lags when loading new batch of rows

## Bad

Tip: count how many times message 'sizeOfItemIn called’ is printed to console after new batch of rows is loaded or when touching Show/Hide button


# What if Collection View 4 performance is still not sufficient?

Then I would give a try to [AsyncDisplayKit](http://asyncdisplaykit.org) developed by Facebook
