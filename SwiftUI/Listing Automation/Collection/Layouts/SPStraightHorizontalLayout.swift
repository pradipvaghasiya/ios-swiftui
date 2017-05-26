//
//  SPStraightHorizontalLayout.swift
//  SwiftUI
//
//  Created by Pradip V on 2/11/16.
//  Copyright © 2016 Speedui. All rights reserved.
//

import UIKit
private let kDefaultRows : UInt = 1
private let kDefaultWidth : CGFloat = 0

open class SPStraightHorizontalLayout: SPStraightLayout {
    ///Denotes no.of rows in horizontal layout
    open lazy var noOfRows : UInt = kDefaultRows
    
    ///Denotes width of an item
    open lazy var itemWidth : CGFloat = kDefaultWidth
    
    ///For this layout height of an item for entire section would be same. So section wise width is stored in this dictionary.
    var itemHeightDictionary : [Int : CGFloat] = [:]
    
    /// Designated intializer
    override public init(){
        super.init()
    }
    
    public init(NoOfRows rows: UInt) {
        super.init()
        self.noOfRows = rows
    }
    
    public init(NoOfRows rows: UInt, ItemWidth itemWidth : CGFloat) {
        super.init()
        self.noOfRows = rows
        self.itemWidth = itemWidth
    }
    
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override open func prepare() {
        // Clear all values in itemWidthHeightDictionary
        itemHeightDictionary.removeAll(keepingCapacity: false)
        
        super.prepare()
    }
    
    final override func calculateItemWidthAndHeightAt(IndexPath indexPath: IndexPath) -> (itemWidth: CGFloat, itemHeight: CGFloat)
    {
        
        // If height has already been calculated for this section then return it.
        if  let itemHeight = self.itemHeightDictionary[indexPath.section]{
            guard self.itemWidthAt(IndexPath: indexPath) != 0 else{
                return(itemHeight, itemHeight)
            }
            
            return (self.itemWidthAt(IndexPath: indexPath), itemHeight)
        }
        
        let collectionViewVisibleHeight = self.collectionView!.bounds.size.height - self.collectionView!.contentInset.bottom - self.collectionView!.contentInset.top
        
        let sectionInsetForCurrentSection = self.sectionInset(ForSection: indexPath.section)
        
        //Usable Width for actual content is bounds - section insets - interitemspacing between all columns.
        let usableHeight : CGFloat = collectionViewVisibleHeight - sectionInsetForCurrentSection.top - sectionInsetForCurrentSection.bottom - (CGFloat(noOfRows(ForSection: indexPath.section) - 1) * self.interItemSpacing(ForSection: indexPath.section))
        
        // Item width is usable height / no of rows
        let itemHeight = usableHeight/CGFloat(noOfRows(ForSection: indexPath.section))
        
        // Save Height for this section
        itemHeightDictionary[indexPath.section] = itemHeight
        
        guard itemWidthAt(IndexPath: indexPath) != 0 else{
            return(itemHeight,itemHeight)
        }
        
        return (itemWidthAt(IndexPath: indexPath), itemHeight)
    }
    
    override func calcualateOriginOfFirstItemOfSectionAt(IndexPath indexPath: IndexPath) -> (x: CGFloat, y: CGFloat) {
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
    
    override func calcualateOriginOfNonFirstItemOfSectionAt(IndexPath indexPath : IndexPath) -> (x: CGFloat, y: CGFloat){
        
        // Item which should start from new line can be calculated based on noOfColumns Required
        if indexPath.item % noOfRows(ForSection: indexPath.section) == 0 {
            return self.calculateOriginOfNonFirstOnNewRowItemAt(IndexPath: indexPath)
        }
        
        return self.calculateOriginOfNonFirstOnSameRowItemAt(IndexPath: indexPath)
    }
    
    /// Calculates Non First item of section which is first item of new row . It always starts from left and below above row of same section leaving spacing.
    ///
    ///:param: indexPath IndexPath For which item Origin need to be calculated.
    ///
    ///:returns: (x: CGFloat, y: CGFloat) Origin of an item
    fileprivate func calculateOriginOfNonFirstOnNewRowItemAt(IndexPath indexPath : IndexPath) -> (x: CGFloat, y: CGFloat){
        let firstItemOfPreviousRowIndexPath = IndexPath(row: indexPath.item - noOfRows(ForSection: indexPath.section), section: indexPath.section)
        
        if let firstItemOfPreviousRowAttributes = self.attributesDictionary[firstItemOfPreviousRowIndexPath] {
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
    fileprivate func calculateOriginOfNonFirstOnSameRowItemAt(IndexPath indexPath : IndexPath) -> (x: CGFloat, y: CGFloat){
        let previousItemOnSameRowIndexPath = IndexPath(item: indexPath.item-1, section: indexPath.section)
        
        let aboveItemIndexPath = IndexPath(item: indexPath.item - noOfRows(ForSection: indexPath.section), section: indexPath.section)
        
        var x : CGFloat = 0
        var y : CGFloat = 0
        
        if let previousItemOnSameRowAttributes = self.attributesDictionary[previousItemOnSameRowIndexPath] {
            // Previous item of same row origin x + previous item width + inter item spacing
            x = previousItemOnSameRowAttributes.frame.origin.x
            y = previousItemOnSameRowAttributes.frame.origin.y + previousItemOnSameRowAttributes.frame.size.height + self.interItemSpacing(ForSection: indexPath.section)
        }
        
        // For each section starting from second row one will get the above item. Then x will depend on width of left item.
        if let aboveItemAttributes = self.attributesDictionary[aboveItemIndexPath]{
            x = aboveItemAttributes.frame.origin.x + aboveItemAttributes.frame.size.width + self.lineSpacing(ForSection: indexPath.section)
        }
        
        return (x,y)
    }
    
    // MARK: Content Size
    final override public var collectionViewContentSize : CGSize {
        if let noOfSections = self.collectionView?.numberOfSections{
            if noOfSections == 0 {
                return CGSize(width: 0, height: 0)
            }
            
            let lastSection = noOfSections - 1
            
            if let (sectionWidth, _) = sectionSizeDictionary[lastSection]{
                return CGSize(width: sectionWidth + self.sectionInset(ForSection: lastSection).right, height: self.collectionView!.bounds.size.height - self.collectionView!.contentInset.top - self.collectionView!.contentInset.bottom)
            }
        }
        return CGSize(width: 0, height: 0)
    }
    
    open override func finalizeAnimatedBoundsChange() {
        super.finalizeAnimatedBoundsChange()
        updateContentOffsetForHorizontalLayoutOnBoundsChange()
    }
}

// MARK: Helper methods
extension SPStraightHorizontalLayout{
    
    final func noOfRows(ForSection section : Int) -> Int{
        if let delegate = self.delegate as? SPStraightHorizontalLayoutDelegate{
            if let noOfRows = delegate.noOfRows?(ForSection: section){
                return Int(noOfRows)
            }
        }
        
        return Int(noOfRows)
    }
    
    final func itemWidthAt(IndexPath indexPath : IndexPath) -> CGFloat{
        if let delegate = self.delegate as? SPStraightHorizontalLayoutDelegate{
            if let itemWidth = delegate.itemWidthAt?(IndexPath: indexPath){
                return itemWidth
            }
        }
        
        return itemWidth
    }
}
