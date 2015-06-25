//
//  SPListingSection.swift
//  SpeedKit
//
//  Created by Pradip Vaghasiya on 15/11/14.
//  Copyright (c) 2014 Happyfall. All rights reserved.
//

import UIKit

/// SPListingSection contains section details of Tableview/CollectionView to be used in any listing UI Automation.
///
/// SPListingSection contains SPListingCellGroup array. SPListingCellGroup in turns contains list of similar cells. So Section is set of set of similar cells. Refer SPListingCellGroup for more details
public class SPListingSection : CollectionType{
   
   /// Array of SPListingCellGroup containing cell/item details for this section.
   private var spCellGroupArray : [SPListingCellGroup]
   
   public var startIndex = 0
   public var endIndex = 0

   /// Computed property : Calculates cell count using Cell Data Array
   var sectionTotalCellCount : UInt{
      var lSectionTotalCellCount : UInt = 0
      for cellData in self.spCellGroupArray{
         lSectionTotalCellCount += cellData.cellCount
      }
      return lSectionTotalCellCount
   }
   
   /// Designated initialiser for given cells/items array.
   init(CellGroups cellGroups:[SPListingCellGroup]){
      self.spCellGroupArray = cellGroups
      endIndex = spCellGroupArray.count
   }
   
}

extension SPListingSection{
   public subscript (i : Int) -> SPListingCellGroup{
      get{
         return spCellGroupArray[i]
      }
      
      set{
         spCellGroupArray[i] = newValue
         endIndex = spCellGroupArray.count
      }
   }
}
