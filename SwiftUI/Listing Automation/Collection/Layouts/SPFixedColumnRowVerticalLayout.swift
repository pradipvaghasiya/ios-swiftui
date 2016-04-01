//
//  SPFixedColumnRowVerticalLayout.swift
//  SwiftUIDemo
//
//  Created by Pradip Vaghasiya on 01/05/15.
//  Copyright (c) 2015 Happyfall. All rights reserved.
//

import UIKit


public final class SPFixedColumnRowVerticalLayout: SPFixedColumnRowLayout {
    
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
        
        let collectionViewVisibleHeight = self.collectionView!.bounds.size.height - self.collectionView!.contentInset.top - self.collectionView!.contentInset.bottom
        
        let collectionViewVisibleWidth = self.collectionView!.bounds.size.width - self.collectionView!.contentInset.right - self.collectionView!.contentInset.left
        
        let sectionInsetForCurrentSection = self.sectionInset(ForSection: indexPath.section)
        
        //Usable Width for actual content is bounds - section insets - interitemspacing between all columns.
        let usableWidth : CGFloat = collectionViewVisibleWidth - sectionInsetForCurrentSection.left - sectionInsetForCurrentSection.right - (CGFloat(self.noOfColumns(ForSection: indexPath.section) - 1) * self.interItemSpacing(ForSection: indexPath.section))
        
        //Usable Width for actual content is bounds - section insets - interitemspacing between all rows .
        let usableHeight : CGFloat = collectionViewVisibleHeight - sectionInsetForCurrentSection.top - sectionInsetForCurrentSection.bottom - (CGFloat(self.noOfRows(ForSection: indexPath.section) - 1) * self.lineSpacing(ForSection: indexPath.section))
        
        // Item width is usable width / no of columns
        let itemWidth = usableWidth/CGFloat(noOfColumns(ForSection: indexPath.section))
        
        // Item Height is usable Height / no of Rows
        let itemHeight = usableHeight/CGFloat(self.noOfRows(ForSection: indexPath.section))
        
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
        
        if let (_, previousSectionHeight) = sectionSizeDictionary[indexPath.section - 1]{
            
            let x = sectionInsetForCurrentSection.left
            let y = previousSectionHeight + self.sectionInset(ForSection: indexPath.section - 1).bottom + sectionInsetForCurrentSection.top
            
            return (x,y)
        }
        
        SPLogger.logWarning(Message: "SectionSizeArray is not updated for section \(indexPath.section)")
        return (0,0)
    }
    
    override func calcualateOriginOfNonFirstItemOfSectionAt(IndexPath indexPath : NSIndexPath) -> (x: CGFloat, y: CGFloat){
        
        // Item which should start from new line can be calculated based on noOfColumns Required
        if indexPath.item % noOfColumns(ForSection: indexPath.section) == 0 {
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
        let firstItemOfPreviousRowIndexPath = NSIndexPath(forRow: indexPath.item - noOfColumns(ForSection: indexPath.section), inSection: indexPath.section)
        
        if let firstItemOfPreviousRowAttributes = self.attributesDictionary[firstItemOfPreviousRowIndexPath] {
            let x = firstItemOfPreviousRowAttributes.frame.origin.x
            // Above item y + Height + Line Spacing
            let y = firstItemOfPreviousRowAttributes.frame.origin.y + firstItemOfPreviousRowAttributes.frame.size.height + self.lineSpacing(ForSection: indexPath.section)
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
            // Previous item of same row origin x + previous item width + inter item spacing
            let x = previousItemOnSameRowAttributes.frame.origin.x + previousItemOnSameRowAttributes.frame.size.width + self.interItemSpacing(ForSection: indexPath.section)
            let y = previousItemOnSameRowAttributes.frame.origin.y
            
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
            
            if let (_, sectionHeight) = sectionSizeDictionary[lastSection]{
                return CGSizeMake(self.collectionView!.bounds.size.width - self.collectionView!.contentInset.left - self.collectionView!.contentInset.right, sectionHeight + self.sectionInset(ForSection: lastSection).bottom)
            }
        }
        return CGSizeMake(0, 0)
    }
    
    public override func finalizeAnimatedBoundsChange() {
        super.finalizeAnimatedBoundsChange()
        updateContentOffsetForVerticalLayoutOnBoundsChange()
    }
    
}
