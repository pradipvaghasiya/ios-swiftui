//
//  SPStraightVerticalLayout.swift
//  SwiftUIDemo
//
//  Created by Pradip Vaghasiya on 05/05/15.
//  Copyright (c) 2015 SpeedUI. All rights reserved.
//

import UIKit
private let kDefaultColumns : UInt = 3
private let kDefaultHeight : CGFloat = 44

public class SPStraightVerticalLayout: SPStraightLayout {
   ///Denotes no.of columns in vertical layout
   public lazy var noOfColumns : UInt = kDefaultColumns
   
   ///Denotes height of an item
   public lazy var itemHeight : CGFloat = kDefaultHeight
   
   ///For this layout width of an item for entire section would be same. So section wise width is stored in this dictionary.
   var itemWidthDictionary : [Int : CGFloat] = [:]

   /// Designated intializer
   override public init(){
      super.init()
   }
   
   public init(NoOfColumns columns: UInt) {
      super.init()
      self.noOfColumns = columns
   }
   
   public init(NoOfColumns columns: UInt, ItemHeight itemHeight : CGFloat) {
      super.init()
      self.noOfColumns = columns
      self.itemHeight = itemHeight
   }
   
   required public init(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
   }
   
   override public func prepareLayout() {
      // Clear all values in itemWidthHeightDictionary
      itemWidthDictionary.removeAll(keepCapacity: false)

      super.prepareLayout()
   }
   
   final override func calculateItemWidthAndHeightAt(IndexPath indexPath: NSIndexPath) -> (itemWidth: CGFloat, itemHeight: CGFloat)
   {
      
      // If itemWidth has already been calculated for this section then return it.
      if  let itemWidth = self.itemWidthDictionary[indexPath.section]{
         return (itemWidth,self.itemHeightAt(IndexPath: indexPath))
      }

      let collectionViewVisibleWidth = self.collectionView!.bounds.size.width - self.collectionView!.contentInset.right - self.collectionView!.contentInset.left
      
      let sectionInsetForCurrentSection = self.sectionInset(ForSection: indexPath.section)
      
      //Usable Width for actual content is bounds - section insets - interitemspacing between all columns.
      let usableWidth : CGFloat = collectionViewVisibleWidth - sectionInsetForCurrentSection.left - sectionInsetForCurrentSection.right - (CGFloat(self.noOfColumns(ForSection: indexPath.section) - 1) * self.interItemSpacing(ForSection: indexPath.section))
      
      // Item width is usable width / no of columns
      let itemWidth = usableWidth/CGFloat(noOfColumns(ForSection: indexPath.section))

      // Save Width for this section
      self.itemWidthDictionary[indexPath.section] = itemWidth

      return (itemWidth, self.itemHeightAt(IndexPath: indexPath))
   }
   
   final override func calcualateOriginOfFirstItemOfSectionAt(IndexPath indexPath: NSIndexPath) -> (x: CGFloat, y: CGFloat) {
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
      
      let aboveItemIndexPath = NSIndexPath(forItem: indexPath.item-self.noOfColumns(ForSection: indexPath.section), inSection: indexPath.section)
      
      var x : CGFloat = 0
      var y : CGFloat = 0
      
      if let previousItemOnSameRowAttributes = self.attributesDictionary[previousItemOnSameRowIndexPath] {
         // Previous item of same row origin x + previous item width + inter item spacing
         x = previousItemOnSameRowAttributes.frame.origin.x + previousItemOnSameRowAttributes.frame.size.width + self.interItemSpacing(ForSection: indexPath.section)
         y = previousItemOnSameRowAttributes.frame.origin.y

      }
      
      // For each section starting from second row one will get the above item. Then y will depend on height of above item.
      if let aboveItemAttributes = self.attributesDictionary[aboveItemIndexPath]{
         y = aboveItemAttributes.frame.origin.y + aboveItemAttributes.frame.size.height + self.lineSpacing(ForSection: indexPath.section)
      }
      
      return (x,y)
   }

   // MARK: Content Size
   final override public func collectionViewContentSize() -> CGSize {
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

   // Update layout on bounds change
   final override public func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
      if newBounds.width != self.collectionView!.bounds.size.width{
         return true
      }
      return false
   }
}

// MARK: Helper methods
extension SPStraightVerticalLayout{
   
   ///Gets No Of Columns required for that section if implemented by delegate otherwise will return the value present in instance variable.
   ///
   ///:param: section for which No Of Columns is required.
   ///
   ///:returns: Int No Of Columns
   final func noOfColumns(ForSection section : Int) -> Int{
      if let delegate = self.delegate as? SPFixedColumnRowLayoutDelegate{
         if let noOfColumns = delegate.noOfColumns?(ForSection: section){
            return Int(noOfColumns)
         }
      }
      
      return Int(self.noOfColumns)
   }
   
   ///Gets ItemHeight for this indexPath if implemented by delegate otherwise will return the value present in instance variable.
   ///
   ///:param: IndexPath for which ItemHeight is required.
   ///
   ///:returns: CGFloat ItemHeight
   final func itemHeightAt(IndexPath indexPath : NSIndexPath) -> CGFloat{
      if let delegate = self.delegate as? SPStraightVerticalLayoutDelegate{
         if let itemHeight = delegate.itemHeightAt?(IndexPath: indexPath){
            return itemHeight
         }
      }

      return self.itemHeight
   }
}

