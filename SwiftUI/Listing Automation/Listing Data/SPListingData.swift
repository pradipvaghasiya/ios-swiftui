//
//  SPListingData.swift
//  SpeedKitDemo
//
//  Created by Pradip Vaghasiya on 13/04/15.
//  Copyright (c) 2015 Happyfall. All rights reserved.
//

import Foundation


/// SPListingData contains content details (Section list) of Tableview/CollectionView to be used in any listing UI Automation.
///
/// It has list of helper methods/Properties.
///
/// 1. Calculates Section Count.
/// 2. Calculates Row Count of given section Index.
/// 3. Extracts Cell details at given indexPath.
final class SPListingData{
   /// Array of SPListingSection contains content details (Section list) of Tableview/CollectionView to be used in any listing UI Automation.
   var spListingSectionArray : [SPListingSection]
   
   /// Designated initialiser for given SPListingSection.
   init (SectionArray spListingSectionArray : [SPListingSection]){
      self.spListingSectionArray = spListingSectionArray
   }
   
   /// Computed property : Calculates section count
   var sectionCount : Int{
      return self.spListingSectionArray.count
   }
   
}


extension SPListingData{
   /// Calculates Row Count of given section Index.
   ///
   /// :param: atIndex Index of section for which cell count is required.
   ///
   /// :returns: Cell Count of given section index.
   func cellCountOfSection(atIndex:UInt) -> UInt{
      if UInt(self.spListingSectionArray.count) > atIndex {
         let sectionCellData = self.spListingSectionArray[Int(atIndex)]
         return sectionCellData.sectionTotalCellCount
      }
      return 0
   }
   
   /// Extracts Cell details at given indexPath.
   ///
   /// :param: indexPath IndexPath of section for which cell data is required.
   ///
   /// :returns: SPListingCellGroup and index of similar Cell data array (cellModelArray in SPListingCellGroup) of given section indexPath.
   func getListingCellGroupWithIndexOfCellModelArray(ForIndexPath indexPath:NSIndexPath) -> (SPListingCellGroup, CellModelIndex: Int)?
   {
      var startIndexOfCellFound : Int = 0
      var totalCellCountParsedFromSectionDataArray : Int = 0
      
      if self.spListingSectionArray.count > indexPath.section{
         // Get the Section Data
         let sectionCellData = self.spListingSectionArray[indexPath.section]
         
         // Loop through all CellData in that SectionData
         for cellData in sectionCellData.spCellGroupArray{
            
            // Check total Cell count present in this cell data set and add until the indexPath.Row is not reached.
            totalCellCountParsedFromSectionDataArray +=  Int(cellData.cellCount)
            if indexPath.row < totalCellCountParsedFromSectionDataArray {
               
               //Once the addition crosses the indexpath.row. You get the celldata array where it is present. Subtract initial index of that data set from indexpath.row so you will get index of the item in that particular celldata array.
               return (cellData, indexPath.row - startIndexOfCellFound)
            }
            
            // Save the starindex of each Cell Data Array
            startIndexOfCellFound += startIndexOfCellFound + Int(cellData.cellCount)
         }
      }
      return nil;
   }
}
