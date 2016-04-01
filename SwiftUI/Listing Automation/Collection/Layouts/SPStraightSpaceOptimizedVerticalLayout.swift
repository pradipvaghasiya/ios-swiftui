//
//  SPStraightSpaceOptimizedVerticalLayout.swift
//  SwiftUI
//
//  Created by Pradip Vaghasiya on 07/05/15.
//  Copyright (c) 2015 Happyfall. All rights reserved.
//

import UIKit

public final class SPStraightSpaceOptimizedVerticalLayout: SPStraightVerticalLayout {
   
   ///IndexPath array which indicates that the item is no more the last item in the column.
   final var nonLastItemIndexPathArray : [NSIndexPath] = []
   
   override public func prepareLayout() {
      // Clear All indexpaths
      self.nonLastItemIndexPathArray.removeAll(keepCapacity: false)
      
      super.prepareLayout()
   }
   
   override func calcualateOriginOfNonFirstItemOfSectionAt(IndexPath indexPath: NSIndexPath) -> (x: CGFloat, y: CGFloat) {
      // Ignore if this is first row of a section.
      if indexPath.item < self.noOfColumns(ForSection: indexPath.section){
         return super.calcualateOriginOfNonFirstItemOfSectionAt(IndexPath: indexPath)
      }
      
      if let lastItemInShortestColumnIndexPath = self.getLastItemInShortestColumnIndexPath(AtIndexPath: indexPath){
         nonLastItemIndexPathArray.append(lastItemInShortestColumnIndexPath)
         
         if let aboveItemWhichIsShortestAttributes = self.attributesDictionary[lastItemInShortestColumnIndexPath]{
            let x = aboveItemWhichIsShortestAttributes.frame.origin.x
            let y = aboveItemWhichIsShortestAttributes.frame.origin.y + aboveItemWhichIsShortestAttributes.size.height + self.lineSpacing(ForSection: indexPath.section)
            
            return (x,y)
         }
         
         SPLogger.logWarning(Message: "attributesDictionary is not updated for indexPath \(indexPath.section) : \(indexPath.item)")
         return (0,0)
      }else{
         SPLogger.logWarning(Message: "lastItemInShortestColumnIndexPath not found for \(indexPath.section) : \(indexPath.item)")
         return (0,0)
      }
   }
   
   ///gets the item which is last in shortest column
   ///
   ///:param:IndexPath before which items need to be calculated
   ///
   ///:returns: IndexPath of item which is last in shortest column.
   func getLastItemInShortestColumnIndexPath(AtIndexPath indexPath:NSIndexPath) -> NSIndexPath?{
      var currentPreviousItemOffset = 0
      var shortestColumnHeight : CGFloat?
      var lastItemInShortestColumnIndexPath : NSIndexPath?
      
      while indexPath.item - currentPreviousItemOffset >= 0{
         currentPreviousItemOffset += 1
         
         let currentPreviousItemOffsetIndexPath = NSIndexPath(forItem: indexPath.item - currentPreviousItemOffset, inSection: indexPath.section)
         
         // If item is in middle then continue
         if nonLastItemIndexPathArray.contains(currentPreviousItemOffsetIndexPath){
            continue
         }
         
         // Get the attribute of current previous offset indexpath
         if let attribuets = self.attributesDictionary[currentPreviousItemOffsetIndexPath]{
            let currentColumnHeight = attribuets.frame.origin.y + attribuets.frame.size.height + self.lineSpacing(ForSection: currentPreviousItemOffsetIndexPath.section)

            if let storedColumnHeight = shortestColumnHeight{
               if currentColumnHeight < storedColumnHeight{
                  shortestColumnHeight = currentColumnHeight
                  lastItemInShortestColumnIndexPath = currentPreviousItemOffsetIndexPath
               }
            }else{
               shortestColumnHeight = currentColumnHeight
               lastItemInShortestColumnIndexPath = currentPreviousItemOffsetIndexPath
            }
         }
      }
      
      return lastItemInShortestColumnIndexPath
   }
   
}
