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
class SPListingSection{

    /// Array of SPListingCellGroup containing cell/item details for this section.
    var spCellGroupArray : [SPListingCellGroup]
        
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
    }
    
}
