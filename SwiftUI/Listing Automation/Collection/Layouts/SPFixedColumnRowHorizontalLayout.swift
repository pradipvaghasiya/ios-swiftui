//
//  SPFixedColumnRowHorizontalLayout.swift
//  SwiftUIDemo
//
//  Created by Pradip Vaghasiya on 01/05/15.
//  Copyright (c) 2015 Happyfall. All rights reserved.
//

import UIKit

public final class SPFixedColumnRowHorizontalLayout: SPFixedColumnRowLayout {
    override public init(){
        super.init()
    }
    
    override public init(NoOfRows rows: UInt, NoOfColumns columns: UInt) {
        super.init(NoOfRows: rows, NoOfColumns: columns)
    }
    
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: Attributes Calculation
    override func calculateItemWidthAndHeightAt(IndexPath indexPath : NSIndexPath) -> (itemWidth: CGFloat, itemHeight: CGFloat){
        
        // If itemWidth and itemHeight have already been calculated for this section then return it.
        if  let (itemWidth,itemHeight) = self.itemWidthHeightDictionary[indexPath.section]{
            return (itemWidth,itemHeight)
        }
        
        //      println(self.collectionView?.contentInset.top)
        //      println(self.collectionView?.bounds)
        
        let section = indexPath.section
        
        let collectionViewVisibleHeight = self.collectionView!.bounds.size.height - self.collectionView!.contentInset.top - self.collectionView!.contentInset.bottom
        
        let collectionViewVisibleWidth = self.collectionView!.bounds.size.width - self.collectionView!.contentInset.right - self.collectionView!.contentInset.left
        
        let sectionInsetForCurrentSection = self.sectionInset(ForSection: section)
        
        //Usable Width for actual content is bounds - section insets - interitemspacing between all columns.
        let usableWidth : CGFloat = collectionViewVisibleWidth - sectionInsetForCurrentSection.left - sectionInsetForCurrentSection.right - (CGFloat(self.noOfColumns(ForSection: section) - 1) * self.lineSpacing(ForSection: section))
        
        //Usable Width for actual content is bounds - section insets - interitemspacing between all rows .
        let usableHeight : CGFloat = collectionViewVisibleHeight - sectionInsetForCurrentSection.top - sectionInsetForCurrentSection.bottom - (CGFloat(self.noOfRows(ForSection: section) - 1) * self.interItemSpacing(ForSection: section))
        
        // Item width is usable width / no of columns
        let itemWidth = usableWidth/CGFloat(self.noOfColumns(ForSection: section))
        
        // Item Height is usable Height / no of Rows
        let itemHeight = usableHeight/CGFloat(self.noOfRows(ForSection: section))
        
        // Save Height and Width for this section
        self.itemWidthHeightDictionary[indexPath.section] = (itemWidth,itemHeight)
        
        return (itemWidth,itemHeight)
        
    }
    
    override func calcualateOriginOfFirstItemOfSectionAt(IndexPath indexPath : NSIndexPath) -> (x: CGFloat, y: CGFloat){
        let sectionInsetForCurrentSection = self.sectionInset(ForSection: indexPath.section)
        
        if indexPath.section == 0{
            // First item of a collection view. Top left corner with SectionInset in mind
            return (sectionInsetForCurrentSection.left, sectionInsetForCurrentSection.top)
        }
        
        // Item 0 of next sections should depend on previous section.
        
        if let (previousSectionWidth, _) = sectionSizeDictionary[indexPath.section - 1]{
            
            let x = previousSectionWidth + self.sectionInset(ForSection: indexPath.section - 1).right + sectionInsetForCurrentSection.left
            let y = sectionInsetForCurrentSection.top
            
            return (x,y)
        }
        
        SPLogger.logWarning(Message: "SectionSizeArray is not updated for section \(indexPath.section)")
        return (0,0)
    }
    
    override func calcualateOriginOfNonFirstItemOfSectionAt(IndexPath indexPath : NSIndexPath) -> (x: CGFloat, y: CGFloat){
        
        // Item which should start from new line can be calculated based on noOfColumns Required
        if indexPath.item % self.noOfRows(ForSection: indexPath.section) == 0 {
            return self.calculateOriginOfNonFirstOnNewRowItemAt(IndexPath: indexPath)
        }
        
        return self.calculateOriginOfNonFirstOnSameRowItemAt(IndexPath: indexPath)
    }
    
    /// Calculates Non First item of section which is first item of new row . It always starts from left and below above row of same section leaving spacing.
    ///
    ///:param: indexPath IndexPath For which item Origin need to be calculated.
    ///
    ///:returns: (x: CGFloat, y: CGFloat) Origin of an item
    private func calculateOriginOfNonFirstOnNewRowItemAt(IndexPath indexPath : NSIndexPath) -> (x: CGFloat, y: CGFloat){
        let firstItemOfPreviousRowIndexPath = NSIndexPath(forRow: indexPath.item - self.noOfRows(ForSection: indexPath.section), inSection: indexPath.section)
        
        if let firstItemOfPreviousRowAttributes = self.attributesDictionary[firstItemOfPreviousRowIndexPath] {
            // left item x + width + Line Spacing
            
            let x = firstItemOfPreviousRowAttributes.frame.origin.x + firstItemOfPreviousRowAttributes.frame.size.width + self.lineSpacing(ForSection: indexPath.section)
            
            let y = firstItemOfPreviousRowAttributes.frame.origin.y
            return (x,y)
        }
        
        SPLogger.logWarning(Message: "attributesDictionary is not updated for indexPath \(indexPath.section) : \(indexPath.item)")
        return (0,0)
    }
    
    /// Calculates Non First item of section which is on same row. It always starts from left and below after previous item of section leaving spacing.
    ///
    ///:param: indexPath IndexPath For which item Origin need to be calculated.
    ///
    ///:returns: (x: CGFloat, y: CGFloat) Origin of an item
    private func calculateOriginOfNonFirstOnSameRowItemAt(IndexPath indexPath : NSIndexPath) -> (x: CGFloat, y: CGFloat){
        let previousItemOnSameRowIndexPath = NSIndexPath(forItem: indexPath.item-1, inSection: indexPath.section)
        
        if let previousItemOnSameRowAttributes = self.attributesDictionary[previousItemOnSameRowIndexPath] {
            let x = previousItemOnSameRowAttributes.frame.origin.x
            
            // Previous item of same row origin y + previous item height + inter item spacing
            let y = previousItemOnSameRowAttributes.frame.origin.y + previousItemOnSameRowAttributes.frame.size.height + self.interItemSpacing(ForSection: indexPath.section)
            
            return (x,y)
        }
        
        SPLogger.logWarning(Message: "attributesDictionary is not updated for indexPath \(indexPath.section) : \(indexPath.item)")
        return (0,0)
    }
    
    // MARK: Content Size
    override public func collectionViewContentSize() -> CGSize {
        if let noOfSections = self.collectionView?.numberOfSections(){
            if noOfSections == 0 {
                return CGSizeMake(0, 0)
            }
            
            let lastSection = noOfSections - 1
            
            if let (sectionWidth, _) = sectionSizeDictionary[lastSection]{
                return CGSizeMake(sectionWidth + self.sectionInset(ForSection: lastSection).right,
                    self.collectionView!.bounds.size.height - self.collectionView!.contentInset.top - self.collectionView!.contentInset.bottom)
            }
            
        }
        return CGSizeMake(0, 0)
    }
    
    public override func finalizeAnimatedBoundsChange() {
        super.finalizeAnimatedBoundsChange()
        updateContentOffsetForHorizontalLayoutOnBoundsChange()
    }

    public var currentPageIndex : Int? {
        guard let collectionView = collectionView where pagingEnabled && noOfColumns == 1 else{
            return nil
        }

        let itemWidth =  collectionView.bounds.width + lineSpacing
        let itemNo = ceil(collectionView.contentOffset.x / itemWidth)
        return Int(itemNo)
    }
    
    
    
// On rotation below method needs to be implemented in case of Paging Enabled
// Need to get indexPath from proposedContentOffset and calculate accordingly.
    public override func targetContentOffsetForProposedContentOffset(proposedContentOffset: CGPoint) -> CGPoint {
        
        guard let noOfSections = self.collectionView?.numberOfSections() where noOfSections == 1 else{
            return proposedContentOffset
        }
        
        //Below assumes only one cell is visible per page
        guard pagingEnabled &&
            noOfColumns == 1 &&
        oldBoundsBeforeInvalidationLayout.width > 0
            else{
            return proposedContentOffset
        }

        let itemWidthWithGapBeforeRotation =  oldBoundsBeforeInvalidationLayout.width + lineSpacing
        let itemWidthWithGapAfterRotation =  collectionView!.bounds.width + lineSpacing
        
        let itemNo = ceil(proposedContentOffset.x / itemWidthWithGapBeforeRotation)
        
        return CGPointMake(itemNo * itemWidthWithGapAfterRotation, proposedContentOffset.y)
    }
    
    public override func targetContentOffsetForProposedContentOffset(proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint{
        
        guard pagingEnabled else{
            return proposedContentOffset
        }
        
        //Below assumes only one cell is visible per page
        guard noOfColumns == 1 else{
            return proposedContentOffset
        }
        
        guard let currentPointX = collectionView?.contentOffset.x else{
            return proposedContentOffset
        }
        
        guard var originX = collectionView?.visibleCells()[0].frame.origin.x else{
            return proposedContentOffset
        }
        
        if proposedContentOffset.x < currentPointX{
            collectionView?.visibleCells().forEach{
                if ($0.frame.origin.x < originX){
                    originX = $0.frame.origin.x
                }
            }
            
        }else{
            collectionView?.visibleCells().forEach{
                if ($0.frame.origin.x > originX){
                    originX = $0.frame.origin.x
                }
            }
        }
        
        return CGPointMake(originX, proposedContentOffset.y)
    }
}
