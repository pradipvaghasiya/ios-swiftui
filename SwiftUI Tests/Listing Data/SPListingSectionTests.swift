//
//  SPListingSectionTests.swift
//  SwiftUIDemo
//
//  Created by Pradip Vaghasiya on 19/04/15.
//  Copyright (c) 2015 SpeedUI. All rights reserved.
//

import UIKit
import XCTest
import SwiftUI

class SPListingSectionTests: XCTestCase {
   
   var cellGroup1 = SPListingCellGroup(cellId: "SPTitleLabelCell", cellCount: 12, cellCommonModel: "CommonModel")
   var cellGroup2 = SPListingCellGroup(cellId: "SPTitleLabelCell", cellModelArray: ["1","2","3"])
   var cellGroup3 = SPListingCellGroup(cellId: "SPTitleLabelCell", cellCommonModel: "CommonModel", cellModelArray: ["1","2"])
  
   var cellGroups : [SPListingCellGroup] = []
   var sectionData = SPListingSection(CellGroups: [])
   
   override func setUp() {
      super.setUp()

      cellGroups = [cellGroup1,cellGroup2]
      sectionData = SPListingSection(CellGroups: [cellGroup1,cellGroup2])
   }
   
   override func tearDown() {
      // Put teardown code here. This method is called after the invocation of each test method in the class.
      super.tearDown()
   }
 
   func testSectionDataWithOnlyCellSets(){
      XCTAssert(sectionData.count == 2 &&
         sectionData.sectionTotalCellCount == 15, "SectionData should be created with proper data")
   }
   
   func testSectionDataWithEmptyCells(){
      let sectionData = SPListingSection(CellGroups: [])
      XCTAssert(sectionData.count == 0 &&
         sectionData.sectionTotalCellCount == 0, "SectionData should be created with proper data")
   }
   
   func testSectionCellCountWithOneCellSet(){
      let sectionData = SPListingSection(CellGroups: [cellGroup1])
      XCTAssert(sectionData.count == 1 &&
         sectionData.sectionTotalCellCount == 12, "SectionData should be created with proper data")
   }
   
   func testSectionCellSetAppend(){
      sectionData.append(cellGroup3)
      XCTAssert(sectionData.spCellGroupArray.count == 3 &&
         sectionData.sectionTotalCellCount == 17, "SectionData should be created with proper data")
   }
   
   func testSectionCellSetEdit(){
      sectionData.spCellGroupArray[1] = cellGroup3
      XCTAssert(sectionData.spCellGroupArray.count == 2 &&
         sectionData.sectionTotalCellCount == 14, "SectionData should be created with proper data")
   }
   
   func testSectionCellSetRemove(){
      sectionData.spCellGroupArray.removeLast()
      XCTAssert(sectionData.spCellGroupArray.count == 1 &&
         sectionData.sectionTotalCellCount == 12, "SectionData should be created with proper data")
   }

   func testSectionCellSetRemoveAll(){
      sectionData.spCellGroupArray.removeAll(keepCapacity: false)
      XCTAssert(sectionData.spCellGroupArray.count == 0 &&
         sectionData.sectionTotalCellCount == 0, "SectionData should be created with proper data")
   }
   
   func testSectionCellSetFill(){
      sectionData.spCellGroupArray.removeAll(keepCapacity: false)
      sectionData.spCellGroupArray = [cellGroup3]
      XCTAssert(sectionData.spCellGroupArray.count == 1 &&
         sectionData.sectionTotalCellCount == 2, "SectionData should be created with proper data")
   }


}
