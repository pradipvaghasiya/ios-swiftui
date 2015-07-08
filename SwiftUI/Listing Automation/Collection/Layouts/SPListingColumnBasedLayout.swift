//
//  SPHorizontalLayout.swift
//  SwiftUI
//
//  Created by Pradip Vaghasiya on 09/08/14.
//  Copyright (c) 2014 SpeedUI. All rights reserved.
//

import UIKit

private let kDefaultSpacing : CGFloat = 10.0
private let kDefaultScrollingLines : Int = 3
private let kDefaultNoOfLinesShouldFit : Int = 3

public class SPListingColumnBasedLayout: UICollectionViewLayout {
    
    //Configure Below parameters to use this layout
    //Check whether below paramter needs to be marked as weak or not
    var delegate : SPListingColumnBasedLayoutDelegate?
    var noOfScrollingLines : Int = kDefaultScrollingLines
    var noOfLinesShouldFit : Int = kDefaultNoOfLinesShouldFit   // This will be ignored if lengthOfItem is set
    var lengthOfItem : CGFloat?     // If set noOfLinesShouldFit will be ignored
    
    var isSpaceOptimized : Bool = false     // This will always try to save the space.
    
//    @available(iOS, introduced=8.0)
    var cellAutoResizingOn : Bool = false // If true lengthOfItem & noOfLinesShouldFit will be ignored and will depend on cell preferred attributes method or based on autolayout size.
    var estimatedLengthOfItem : CGFloat = 10  // Optionaly user can set. Used only when cellAutoResizingOn is true. Please make note that this must be less than the runtime expected actual length.
    
    var scrollDirection: UICollectionViewScrollDirection = .Vertical
    var lineSpacing: CGFloat = kDefaultSpacing
    var interitemSpacing: CGFloat = kDefaultSpacing
    var sectionInset: UIEdgeInsets = UIEdgeInsetsMake(kDefaultSpacing, kDefaultSpacing, kDefaultSpacing, kDefaultSpacing)
    var debug = false
    
    // Private
    private var customAttributes : [NSIndexPath:UICollectionViewLayoutAttributes] = [:]
    private var sectionNeedsSpaceOf : [(width:CGFloat, height:CGFloat)] = []
    private var invalidationContext : SPListingColumnBasedLayoutInvalidationContext = SPListingColumnBasedLayoutInvalidationContext()
    private var processedIndexPaths :[NSIndexPath] = []
}


// MARK: Prepare Layout
extension SPListingColumnBasedLayout{
    override public func prepareLayout() {
        if debug {
            print("1. Prepare Layout..")
        }
        
        if let numberOfSections = self.collectionView?.numberOfSections(){
            // Clear Dictionary
            customAttributes.removeAll(keepCapacity: true)
            sectionNeedsSpaceOf.removeAll(keepCapacity: true)
            processedIndexPaths.removeAll(keepCapacity: true)

            // Iterate through each section and items to calculate attributes.
            for var section = 0; section < numberOfSections; ++section {
                // Number of Items in this section
                if let numberOfItems = self.collectionView?.numberOfItemsInSection(section){
                    // Section Insets for this section
                    sectionInset = self.sectionInset(ForSection: section)
                    
                    // Number Of scrolling Lines For this section
                    self.setNoOfScrollingLinesIfProvided(ForSection: section)
                    
                    // Number Of lines should fit in this section
                    self.setNoOfLinesShouldFitIfProvided(ForSection: section)
                    
                    // Line Spacing
                    self.setLineSpacingIfProvided(ForSection: section)
                    
                    // Interitem spacing
                    self.setInterItemSpacingIfProvided(ForSection: section)
                    
                    
                    // Iterate through each item and calculate attributes.
                    // Currently all attributes are being stored into dictionary.
                    // May need to think otherwise for memory constraint applications.
                    for var item = 0; item < numberOfItems; ++item{
                        let indexPath = NSIndexPath(forItem: item, inSection: section)
                        
                        var attributes : UICollectionViewLayoutAttributes
                        
                        switch scrollDirection{
                        case .Horizontal:
                            attributes = self.attributesOfHorizontalLayoutAtIndexPath(indexPath)
                        case .Vertical:
                            attributes = self.attributesOfVerticalLayoutAtIndexPath(indexPath)
                        }
                        
                        if sectionNeedsSpaceOf.count > section{
                            var (storedWidth,storedHeight) = sectionNeedsSpaceOf[section]
                            if storedWidth < (attributes.frame.origin.x + attributes.frame.size.width) {
                                storedWidth = (attributes.frame.origin.x + attributes.frame.size.width)
                            }
                            
                            if storedHeight < (attributes.frame.origin.y + attributes.frame.size.height) {
                                storedHeight = (attributes.frame.origin.y + attributes.frame.size.height)
                            }
                            sectionNeedsSpaceOf[section] = (storedWidth,storedHeight)
                        }else{
                            sectionNeedsSpaceOf += [(width:attributes.frame.size.width,height:attributes.frame.size.height)]
                        }
                        
                        //println(".\(indexPath) .\(attributes.frame) ")
                        customAttributes[indexPath] = attributes
                    }
                }
            }
        }
    }
    
    func sectionInset(ForSection section:Int) -> UIEdgeInsets{
        if let sectionInsetForCurrnetIndexPath = delegate?.collectionView?(self.collectionView, layout: self, insetForSectionAtIndex:section) {
            return sectionInsetForCurrnetIndexPath
        }
        return sectionInset
    }
    
    func setNoOfScrollingLinesIfProvided(ForSection section:Int){
        if let noOfScrollingLinesAtCurrentIndex = delegate?.collectionView?(self.collectionView, layout: self, numberOfScrollingLinesAtSection: section){
            noOfScrollingLines = noOfScrollingLinesAtCurrentIndex
        }
    }
    
    func setNoOfLinesShouldFitIfProvided(ForSection section:Int){
        if let noOfLinesShouldFitAtCurrentIndex = delegate?.collectionView?(self.collectionView, layout: self, numberOfLinesShouldFitInPage:section){
            noOfLinesShouldFit = noOfLinesShouldFitAtCurrentIndex
        }
    }
    
    func setLineSpacingIfProvided(ForSection section:Int){
        if let lineSpacingAtCurrnetSection = delegate?.collectionView?(self.collectionView, layout: self, lineSpacingForSectionAtIndex: section){
            lineSpacing = lineSpacingAtCurrnetSection
        }
    }
    
    func setInterItemSpacingIfProvided(ForSection section:Int){
        if let interItemSpacingAtCurrnetSection = delegate?.collectionView?(self.collectionView, layout: self, interitemSpacingForSectionAtIndex: section){
            interitemSpacing = interItemSpacingAtCurrnetSection
        }
    }
    
    // Below function is recursive, Make sure to make it better.. You can use Swift Memoize
    func attributesOfVerticalLayoutAtIndexPath(indexPath:NSIndexPath) -> UICollectionViewLayoutAttributes{
        if let attributes = customAttributes[indexPath] {
            return attributes
        }
        
        let attributes : UICollectionViewLayoutAttributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
        
        if let collectionViewBounds = self.collectionView?.bounds {
            
            let usableWidth : CGFloat = collectionViewBounds.size.width - sectionInset.left - sectionInset.right - (CGFloat(noOfScrollingLines-1))*interitemSpacing
            
            let itemWidth = usableWidth/CGFloat(noOfScrollingLines)
            var itemHeight:CGFloat
            if let lengthOfCurrentItem = self.itemLength(ForIndexPath: indexPath, widthOrHeight:itemWidth){
                itemHeight = lengthOfCurrentItem
            }else{
                let usableHeight : CGFloat = collectionViewBounds.size.height - sectionInset.top - sectionInset.bottom - (CGFloat(noOfLinesShouldFit-1))*lineSpacing
                itemHeight = usableHeight/CGFloat(noOfLinesShouldFit)
            }
            
            
            if indexPath.item == 0 {
                if indexPath.section == 0{
                    attributes.frame = CGRectMake(sectionInset.left, sectionInset.top, itemWidth, itemHeight)
                    return attributes
                }
                
                // Item 0 of next sections should depend on previous section.
                if let _ = self.collectionView?.numberOfItemsInSection(indexPath.section-1){
                    var firstItemOfNewSectionFrame = CGRect()
                    
                    let (_,storedHeight) = sectionNeedsSpaceOf[indexPath.section-1]
                    
                    firstItemOfNewSectionFrame.origin.y = storedHeight + self.sectionInset(ForSection: indexPath.section-1).bottom + sectionInset.top
                    firstItemOfNewSectionFrame.origin.x = sectionInset.left
                    firstItemOfNewSectionFrame.size = CGSizeMake(itemWidth, itemHeight)
                    attributes.frame = firstItemOfNewSectionFrame
                    return attributes
                }
            }
            
            // For Space optimised see last childs position
            if isSpaceOptimized && indexPath.item >= noOfScrollingLines{
                if let (_,leastIndexPath) = self.getLeastEndOfNode(AtIndexPath: indexPath, andLength: itemHeight){
//                    println(".\(indexPath.item) .\(leastIndexPath.item) .\(leastEndHeight)")
                    processedIndexPaths.append(leastIndexPath)

                    let aboveItemFrame = self.attributesOfVerticalLayoutAtIndexPath(leastIndexPath).frame
                    
                    var itemFrame = CGRect()
                    itemFrame.origin.x = aboveItemFrame.origin.x
                    itemFrame.origin.y = aboveItemFrame.origin.y + aboveItemFrame.size.height + lineSpacing
                    itemFrame.size = CGSizeMake(itemWidth, itemHeight)
                    attributes.frame = itemFrame
                    
                    return attributes
                }else{
                    print("Nil Encounterd")
                }
            }
            
            if indexPath.item % noOfScrollingLines == 0 {
                let aboveItemFrame = self.attributesOfVerticalLayoutAtIndexPath(NSIndexPath(forItem: indexPath.item-noOfScrollingLines, inSection: indexPath.section)).frame
                
                var itemFrame = CGRect()
                itemFrame.origin.x = aboveItemFrame.origin.x
                itemFrame.origin.y = aboveItemFrame.origin.y + aboveItemFrame.size.height + lineSpacing
                itemFrame.size = CGSizeMake(itemWidth, itemHeight)
                attributes.frame = itemFrame
                return attributes
                
            }else{
                let leftItemFrame = self.attributesOfVerticalLayoutAtIndexPath(NSIndexPath(forItem: indexPath.item-1, inSection: indexPath.section)).frame
                
                var itemFrame = CGRect()
                itemFrame.origin.x = leftItemFrame.origin.x + leftItemFrame.size.width + interitemSpacing
                itemFrame.origin.y = leftItemFrame.origin.y
                
                if indexPath.item > noOfScrollingLines{
                    let aboveItemFrame = self.attributesOfVerticalLayoutAtIndexPath(NSIndexPath(forItem: indexPath.item-noOfScrollingLines, inSection: indexPath.section)).frame
                    itemFrame.origin.y = aboveItemFrame.origin.y + aboveItemFrame.size.height + lineSpacing
                }
                
                itemFrame.size = CGSizeMake(itemWidth, itemHeight)
                attributes.frame = itemFrame
                
                return attributes
            }
            
        }
        return attributes
    }
    
    // Function to get the node end which is minimum of all noOfScrolling lines
    func getLeastEndOfNode(AtIndexPath indexPath:NSIndexPath, andLength length:CGFloat) -> (CGFloat,NSIndexPath)?{
        var currentLine = 0
        var oLeastEnd : CGFloat?
        var leastIndexPath : NSIndexPath = indexPath
        
        
        while  indexPath.item - currentLine >= 0{
            currentLine++
            
            let currentIndexPath = NSIndexPath(forItem: indexPath.item - currentLine, inSection: indexPath.section)
            
            if processedIndexPaths.contains(currentIndexPath){
                continue
            }
            
            if let itemAttr = customAttributes[currentIndexPath]{
                let itemFrame = itemAttr.frame
                //println(currentIndexPath.item)
                //println(itemFrame)
                if oLeastEnd == nil{
                    oLeastEnd = itemFrame.origin.y + itemFrame.size.height + lineSpacing
                    leastIndexPath = currentIndexPath
                    continue
                }
                
                if itemFrame.origin.y + itemFrame.size.height + lineSpacing <= oLeastEnd{
                    oLeastEnd = itemFrame.origin.y + itemFrame.size.height + lineSpacing
                    leastIndexPath = currentIndexPath
                }
            }
        }
        
        if let leastEnd = oLeastEnd {
            return (leastEnd,leastIndexPath)
        }
        
        return nil
    }
    
    func attributesOfHorizontalLayoutAtIndexPath(indexPath:NSIndexPath) -> UICollectionViewLayoutAttributes{
        if let attributes = customAttributes[indexPath] {
            return attributes
        }
        
        let attributes : UICollectionViewLayoutAttributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
        
        if let collectionViewBounds = self.collectionView?.bounds {
            let usableHeight : CGFloat = collectionViewBounds.size.height - sectionInset.top - sectionInset.bottom - (CGFloat(noOfScrollingLines-1))*interitemSpacing
            let itemHeight = usableHeight/CGFloat(noOfScrollingLines)
            
            var itemWidth:CGFloat
            if let lengthOfCurrentItem = self.itemLength(ForIndexPath: indexPath, widthOrHeight:itemHeight){
                itemWidth = lengthOfCurrentItem
            }else{
                let usableWidth : CGFloat = collectionViewBounds.size.width - sectionInset.left - sectionInset.right - (CGFloat(noOfLinesShouldFit-1))*lineSpacing
                itemWidth = usableWidth/CGFloat(noOfLinesShouldFit)
            }
            
            if indexPath.item == 0 {
                if indexPath.section == 0{
                    attributes.frame = CGRectMake(sectionInset.left, sectionInset.top, itemWidth, itemHeight)
                    return attributes
                }
                
                // Item 0 of next sections should depend on previous section.
                if let _ = self.collectionView?.numberOfItemsInSection(indexPath.section-1){
                    var firstItemOfNewSectionFrame = CGRect()
                    let (storedWidth,_) = sectionNeedsSpaceOf[indexPath.section-1]
                    
                    firstItemOfNewSectionFrame.origin.x = storedWidth + self.sectionInset(ForSection: indexPath.section-1).right + sectionInset.left
                    firstItemOfNewSectionFrame.origin.y = sectionInset.top
                    firstItemOfNewSectionFrame.size = CGSizeMake(itemWidth, itemHeight)
                    
                    attributes.frame = firstItemOfNewSectionFrame
                    return attributes
                }
            }
            
            if indexPath.item % noOfScrollingLines == 0 {
                let aboveItemFrame = self.attributesOfVerticalLayoutAtIndexPath(NSIndexPath(forItem: indexPath.item-noOfScrollingLines, inSection: indexPath.section)).frame
                
                var itemFrame = CGRect()
                itemFrame.origin.y = aboveItemFrame.origin.y
                itemFrame.origin.x = aboveItemFrame.origin.x + aboveItemFrame.size.width + lineSpacing
                itemFrame.size = CGSizeMake(itemWidth, itemHeight)
                attributes.frame = itemFrame
                
                return attributes
                
            }else{
                let leftItemFrame = self.attributesOfVerticalLayoutAtIndexPath(NSIndexPath(forItem: indexPath.item-1, inSection: indexPath.section)).frame
                
                var itemFrame = CGRect()
                itemFrame.origin.y = leftItemFrame.origin.y + leftItemFrame.size.height + interitemSpacing
                itemFrame.origin.x = leftItemFrame.origin.x
                
                if indexPath.item > noOfScrollingLines{
                    let aboveItemFrame = self.attributesOfVerticalLayoutAtIndexPath(NSIndexPath(forItem: indexPath.item-noOfScrollingLines, inSection: indexPath.section)).frame
                    itemFrame.origin.x = aboveItemFrame.origin.x + aboveItemFrame.size.width + lineSpacing
                }
                
                itemFrame.size = CGSizeMake(itemWidth, itemHeight)
                attributes.frame = itemFrame
                
                return attributes
            }
        }
        return attributes
    }
    
    func itemLength(ForIndexPath indexPath:NSIndexPath, widthOrHeight:CGFloat) -> CGFloat?{
        
        if let preferredSize = invalidationContext.preferredSizeOfItems[indexPath]{
            switch scrollDirection{
            case .Vertical:
                lengthOfItem = preferredSize.height
            case .Horizontal:
                lengthOfItem = preferredSize.width
            }
            
            return lengthOfItem
        }
        
        if cellAutoResizingOn {
            lengthOfItem = estimatedLengthOfItem
            return lengthOfItem
        }
                
        if let lengthAtCurrentIndex = delegate?.collectionView?(self.collectionView, layout: self, lengthOfItemAtIndexPath: indexPath, forGivenWidthOrHeight:widthOrHeight) {
            lengthOfItem = lengthAtCurrentIndex
        }
        
        return lengthOfItem
    }
}

// MARK: Attributes Calculation
extension SPListingColumnBasedLayout{
    override public func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var attribuetsArray : [UICollectionViewLayoutAttributes] = []
        for (_,attributes) in customAttributes{
            if CGRectIntersectsRect(rect, attributes.frame){
                attribuetsArray.append(attributes)
            }
        }
        if debug {
            print("3. layoutAttributesForElementsInRect Count\t: \(attribuetsArray.count)")
        }
        return attribuetsArray
    }
    
    override public func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        return customAttributes[indexPath]
    }
}
// MARK: Content Size
extension SPListingColumnBasedLayout{
    override public func collectionViewContentSize() -> CGSize {
        
        // Keep in mind that at this point noOfScrollingLines will always be default or as per last section value
        // If you need to know noOfScrollingLines for any section other than last you must use setNoOfScrollingLinesIfProvided
        // Same as case with noOfLinesShouldFit
        if let noOfSections = self.collectionView?.numberOfSections(){
            let lastSection = noOfSections - 1
            
            if sectionNeedsSpaceOf.count > 0{
                let (storedWidth,storedHeight) = sectionNeedsSpaceOf[lastSection]
                let lastSectionInset = self.sectionInset(ForSection: lastSection)
                
                if debug {
                    print("2. collectionViewContentSize \t\t\t\t: \(CGSizeMake(storedWidth + lastSectionInset.right, storedHeight + lastSectionInset.bottom))")
                }
                
                return CGSizeMake(storedWidth + lastSectionInset.right, storedHeight + lastSectionInset.bottom)
                
            }
        }
        return CGSizeMake(0, 0)
    }
}

// MARK: Supplymentary Views
extension SPListingColumnBasedLayout{
}

// MARK: Bounds Change
extension SPListingColumnBasedLayout{
    override public func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        // collectionView is still old here.
        // Please note marking this to true will call invalidatelayout() on scrolling also.
        return false
    }
}


// MARK: Cell auto resizing mechanism
extension SPListingColumnBasedLayout{
    @available(iOS, introduced=8.0)
    override public func shouldInvalidateLayoutForPreferredLayoutAttributes(preferredAttributes: UICollectionViewLayoutAttributes, withOriginalAttributes originalAttributes: UICollectionViewLayoutAttributes) -> Bool {
            return cellAutoResizingOn
    }
    
    override public class func invalidationContextClass() -> AnyClass {
        return SPListingColumnBasedLayoutInvalidationContext.classForCoder()
    }
    
    @available(iOS, introduced=8.0)
    override public func invalidationContextForPreferredLayoutAttributes(preferredAttributes: UICollectionViewLayoutAttributes, withOriginalAttributes originalAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutInvalidationContext {
        
        invalidationContext.invalidateItemsAtIndexPaths([preferredAttributes.indexPath])
        invalidationContext.preferredSizeOfItems[preferredAttributes.indexPath] = preferredAttributes.frame.size
        invalidationContext.contentSizeAdjustment = CGSizeZero
        return invalidationContext
    }
}

