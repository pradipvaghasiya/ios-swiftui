//
//  SPFixedColumnRowLayout.swift
//  SwiftUIDemo
//
//  Created by Pradip Vaghasiya on 01/05/15.
//  Copyright (c) 2015 SpeedUI. All rights reserved.
//

import UIKit
private let kDefaultRowsAndColumns : UInt = 3

/// This class must not be used as Layout. Use SPFixedColumnRowVerticalLayout or SPFixedColumnRowHorizontalLayout instead.
public class SPFixedColumnRowLayout: SPCollectionViewLayout {
   ///Denotes no.of rows in vertical layout
   public lazy var noOfRows : UInt = kDefaultRowsAndColumns
   
   ///Denotes no.of columns in vertical layout
   public lazy var noOfColumns : UInt = kDefaultRowsAndColumns
   
   ///For this layout width and height of an item for entire section would be same. So section wise height and width is stored in this dictionary.
   var itemWidthHeightDictionary : [Int : (width : CGFloat, height: CGFloat)] = [:]
   
   /// Designated intializer
   override init(){
      super.init()
   }
   
   init(NoOfRows rows: UInt, NoOfColumns columns: UInt) {
      super.init()
      self.noOfRows = rows
      self.noOfColumns = columns
   }
   
   required public init(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)!
   }
   
   ///TODO: Pagination
   // MARK: Prepare Layout
   override public func prepareLayout() {
      // Clear all values in itemWidthHeightDictionary
      itemWidthHeightDictionary.removeAll(keepCapacity: false)

      super.prepareLayout()
   }
}

// MARK: Helper methods
extension SPFixedColumnRowLayout{
   ///Gets No Of Rows required for that section if implemented by delegate otherwise will return the value present in instance variable.
   ///
   ///:param: section for which No Of Rows is required.
   ///
   ///:returns: Int No Of Rows
   final func noOfRows(ForSection section : Int) -> Int{
      if let delegate = self.delegate as? SPFixedColumnRowLayoutDelegate{
         if let noOfRows = delegate.noOfRows?(ForSection: section){
            return Int(noOfRows)
         }
      }
      
      return Int(self.noOfRows)
   }
   
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
}

