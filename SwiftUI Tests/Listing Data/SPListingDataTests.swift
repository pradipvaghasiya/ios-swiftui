//
//  SPListingData.swift
//  SwiftUIDemo
//
//  Created by Pradip Vaghasiya on 23/04/15.
//  Copyright (c) 2015 SpeedUI. All rights reserved.
//

import UIKit
import XCTest
import SwiftUI

class SPListingDataTests: XCTestCase {
   var spListingData = SPListingData(SectionArray: [])
   var spListingDataWithEmptySectionArray = SPListingData(SectionArray: [])
   
   override func setUp() {
      super.setUp()
      // Put setup code here. This method is called before the invocation of each test method in the class.
      
      spListingData = SPListingData(
         SectionArray: [SPListingSection(
            CellGroups: [
               SPListingCellGroup(cellId: "SPTitleLabelCell", cellCount: 12, cellCommonModel: "CommonModel"),
               SPListingCellGroup(cellId: "SPTitleLabelCell", cellModelArray: ["1","2","3"])
            ])
         ]
      )
      
      spListingDataWithEmptySectionArray = SPListingData(SectionArray: [])

   }
   
   override func tearDown() {
      // Put teardown code here. This method is called after the invocation of each test method in the class.
      super.tearDown()
   }
   
   // MARK: Init Test Cases
   
   func testWithSectionArray(){
      XCTAssert(spListingData.spListingSectionArray.count == 1 &&
         spListingData.sectionCount == 1, "ListingData should be created with proper data")
   }
   
   func testWithEmptySectionArray(){
      XCTAssert(spListingDataWithEmptySectionArray.spListingSectionArray.count == 0 &&
         spListingDataWithEmptySectionArray.sectionCount == 0, "ListingData should be created with proper data")
   }
   
   // MARK: Runtime Test Cases
   
   func testCellCountOfSectionForEmptySectionArray(){
      XCTAssert(spListingDataWithEmptySectionArray.cellCountOfSection(0) == 0, "Empty Section Array cellCountOfSection should be zero")
   }
   
   func testCellCountOfSectionMultipleSectionSingleCellGroup(){
   
      spListingDataWithEmptySectionArray.spListingSectionArray.append(SPListingSection(
         CellGroups: [
            SPListingCellGroup(cellId: "SPTitleLabelCell", cellCount: 12, cellCommonModel: "CommonModel"),
         ]))
      
      spListingDataWithEmptySectionArray.spListingSectionArray.append(SPListingSection(
         CellGroups: [
            SPListingCellGroup(cellId: "SPTitleLabelCell", cellCount: 10, cellCommonModel: "CommonModel"),
         ]))
      
      XCTAssert(spListingDataWithEmptySectionArray.cellCountOfSection(0) == 12 &&
         spListingDataWithEmptySectionArray.cellCountOfSection(1) == 10, "cellCountOfSection conveys wrong value")

   }

   func testCellCountOfSectionWithSectionArray(){
      XCTAssert(spListingData.cellCountOfSection(0) == 15, "cellCountOfSection should be 15")
   }
   
   func testCellCountOfSectionMultipleSectionMultipleCellGroup(){
   
      spListingData.spListingSectionArray.append(SPListingSection(
         CellGroups: [
            SPListingCellGroup(cellId: "SPTitleLabelCell", cellCount: 12, cellCommonModel: "CommonModel"),
            SPListingCellGroup(cellId: "SPTitleLabelCell", cellModelArray: ["1","2"])
         ]))
      
      XCTAssert(spListingData.cellCountOfSection(0) == 15 &&
         spListingData.cellCountOfSection(1) == 14, "cellCountOfSection conveys wrong value")

   }
   
   func testGetListingCellGroupWithIndexOfCellModelArrayForEmptySectionArray(){
      XCTAssert(spListingDataWithEmptySectionArray.getListingCellGroupWithIndexOfCellModelArray(ForIndexPath: IndexPath(index: 0)) == nil, "Should be nil")
   }
   
   func testGetListingCellGroupWithIndexOfCellModelArrayWithSectionArray(){
      var (cellGroup, cellModelIndex) = spListingData.getListingCellGroupWithIndexOfCellModelArray(ForIndexPath: IndexPath(forRow: 14, inSection: 0))!
      
      XCTAssert((cellGroup.cellModelArray[cellModelIndex] as? String) == "3", "Cell Model value should be 3")
   }
   
   func testGetListingCellGroupWithIndexOfCellModelArrayMultipleSectionSingleCellGroup(){
      spListingDataWithEmptySectionArray.spListingSectionArray.append(SPListingSection(
         CellGroups: [
            SPListingCellGroup(cellId: "SPTitleLabelCell", cellModelArray: ["1","2"])
         ]))
      
      spListingDataWithEmptySectionArray.spListingSectionArray.append(SPListingSection(
         CellGroups: [
            SPListingCellGroup(cellId: "SPTitleLabelCell", cellModelArray: ["3","4"])
         ]))
      
      var (cellGroup1, cellModelIndex1) = spListingDataWithEmptySectionArray.getListingCellGroupWithIndexOfCellModelArray(ForIndexPath: IndexPath(forRow: 1, inSection: 0))!

      var (cellGroup2, cellModelIndex2) = spListingDataWithEmptySectionArray.getListingCellGroupWithIndexOfCellModelArray(ForIndexPath: IndexPath(forRow: 0, inSection: 1))!

      XCTAssert((cellGroup1.cellModelArray[cellModelIndex1] as? String) == "2" &&
         (cellGroup2.cellModelArray[cellModelIndex2] as? String) == "3", "Cell Model values are not OK")
   }
   
   func testGetListingCellGroupWithIndexOfCellModelArrayMultipleSectionMultipleCellGroup(){
      
      spListingData.spListingSectionArray.append(SPListingSection(
         CellGroups: [
            SPListingCellGroup(cellId: "SPTitleLabelCell", cellModelArray: ["4","5"]),
            SPListingCellGroup(cellId: "SPTitleLabelCell", cellModelArray: ["1","2"])
         ]))

      var (cellGroup1, cellModelIndex1) = spListingData.getListingCellGroupWithIndexOfCellModelArray(ForIndexPath: IndexPath(forRow: 1, inSection: 0))!  // commonmodel
      
      var (cellGroup2, cellModelIndex2) = spListingData.getListingCellGroupWithIndexOfCellModelArray(ForIndexPath: IndexPath(forRow: 12, inSection: 0))! // should be 1
      
      var (cellGroup3, cellModelIndex3) = spListingData.getListingCellGroupWithIndexOfCellModelArray(ForIndexPath: IndexPath(forRow: 1, inSection: 1))!      // should be 5
      
      var (cellGroup4, cellModelIndex4) = spListingData.getListingCellGroupWithIndexOfCellModelArray(ForIndexPath: IndexPath(forRow: 3, inSection: 1))!  // should be 2 index

      
      XCTAssert(cellGroup1.cellModelArray.count == 0 && (cellGroup1.cellCommonModel as? String) == "CommonModel" &&
         (cellGroup2.cellModelArray[cellModelIndex2] as? String) == "1" &&
         (cellGroup3.cellModelArray[cellModelIndex3] as? String) == "5" &&
         (cellGroup4.cellModelArray[cellModelIndex4] as? String) == "2", "Cell Model values are not OK")
   }
   
   func testGetListingCellGroupWithIndexOfCellModelArrayWithInvalidIndexPath(){
      
      XCTAssert(spListingData.getListingCellGroupWithIndexOfCellModelArray(ForIndexPath: IndexPath(forRow: 18, inSection: 0)) == nil, "Should be nil")
      
      XCTAssert(spListingData.getListingCellGroupWithIndexOfCellModelArray(ForIndexPath: IndexPath(forRow: 0, inSection: 1)) == nil, "Should be nil")

   }


   
}
