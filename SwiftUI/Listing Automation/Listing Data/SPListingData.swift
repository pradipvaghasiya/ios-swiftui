//
//  SPListingData.swift
//  SwiftUIDemo
//
//  Created by Pradip Vaghasiya on 13/04/15.
//  Copyright (c) 2015 SpeedUI. All rights reserved.
//

import Foundation


/// SPListingData contains content details (Section list) of Tableview/CollectionView to be used in any listing UI Automation.
///
/// It has list of helper methods/Properties.
///
/// 1. Calculates Section Count.
/// 2. Calculates Row Count of given section Index.
/// 3. Extracts Cell details at given indexPath.
public final class SPListingData : CollectionType{
   /// Array of SPListingSection contains content details (Section list) of Tableview/CollectionView to be used in any listing UI Automation.
   private var spListingSectionArray : [SPListingSection]
   
   public var startIndex = 0
   public var endIndex = 0

   /// Designated initialiser for given SPListingSection.
   public init (SectionArray spListingSectionArray : [SPListingSection]){
      self.spListingSectionArray = spListingSectionArray
      endIndex = spListingSectionArray.count
   }
   
   /// Computed property : Calculates section count
   var sectionCount : Int{
      return self.spListingSectionArray.count
   }
   
}

extension SPListingData{
   public subscript (i : Int) -> SPListingSection{
      get{
         return spListingSectionArray[i]
      }
      
      set{
         spListingSectionArray[i] = newValue
         endIndex = spListingSectionArray.count
      }
   }
}

extension SPListingData{
   /// Calculates Row Count of given section Index.
   ///
   /// :param: atIndex Index of section for which cell count is required.
   ///
   /// :returns: Cell Count of given section index.
   func cellCountOfSection(atIndex:UInt) -> UInt{
      if UInt(self.count) > atIndex {
         let sectionCellData = self[Int(atIndex)]
         return sectionCellData.sectionTotalCellCount
      }
      return 0
   }
   
   /// Extracts Cell details at given indexPath.
   ///
   /// :param: indexPath IndexPath of section for which cell data is required.
   ///
   /// :returns: SPListingCellGroup and index of similar Cell data array (cellModelArray in SPListingCellGroup) of given section indexPath.
   public func getListingCellGroupWithIndexOfCellModelArray(ForIndexPath indexPath:NSIndexPath) -> (SPListingCellGroup, CellModelIndex: Int)?
   {
      var startIndexOfCellFound : Int = 0
      var totalCellCountParsedFromSectionDataArray : Int = 0
      
      if self.count > indexPath.section{
         // Get the Section Data
         let sectionCellData = self[indexPath.section]
         
         // Loop through all CellData in that SectionData
         for cellData in sectionCellData{
            
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
