//
//  SPFixedColumnRowLayoutTests.swift
//  SwiftUIDemo
//
//  Created by Pradip Vaghasiya on 01/05/15.
//  Copyright (c) 2015 SpeedUI. All rights reserved.
//

import UIKit
import XCTest

class SPFixedColumnRowLayoutTests: XCTestCase {
   var layout = SPFixedColumnRowLayout(NoOfRows: 3, NoOfColumns: 4)
   private var delegate = SPTestFixedColumRowLayout()

   override func setUp() {
      super.setUp()
      // Put setup code here. This method is called before the invocation of each test method in the class.
      
      layout = SPFixedColumnRowLayout(NoOfRows: 3, NoOfColumns:4)
   }

   func testEmptyCreation(){
      layout = SPFixedColumnRowLayout()
      XCTAssert(layout.noOfRows == 3 &&
         layout.noOfColumns == 3, "Layout should be Created")
   }

   func testCreation(){
      XCTAssert(layout.noOfRows == 3 &&
         layout.noOfColumns == 4, "Layout should be Created")
   }
   
   func testNoOfRows(){
      XCTAssert(layout.noOfRows(ForSection: 0) == 3, "Linspacing should be valid.")
   }
   
   func testNoOfColumns(){
      XCTAssert(layout.noOfColumns(ForSection: 1) == 4, "NoOfColumns should be valid.")
   }
   
   func testNoOfRowsFromDelegate(){
      layout.delegate = delegate
      XCTAssert(layout.noOfRows(ForSection: 0) == 3, "Linspacing should be valid.")
   }

   func testNoOfColumnsFromDelegate(){
      layout.delegate = delegate
      XCTAssert(layout.noOfColumns(ForSection: 1) == 3, "NoOfColumns should be valid.")
   }

   func testPrepareLayout(){
      let storyboard = UIStoryboard(name: "SPTestStoryboard", bundle: NSBundle(forClass: self.classForCoder))
      let spCollectionViewTestVC = (storyboard.instantiateViewControllerWithIdentifier("SPCollectionViewTestVC") as? SPCollectionViewTestVC)!
      spCollectionViewTestVC.view.setNeedsDisplay()
      spCollectionViewTestVC.spCollectionView.collectionViewLayout = layout
      layout.delegate = delegate
      spCollectionViewTestVC.spCollectionView.spListingData = SPListingData(SectionArray: [SPListingSection(
         CellGroups: [
            SPListingCellGroup(cellId: "SPTitleTestCCell", cellCount: 15, cellCommonModel: "12"),
            SPListingCellGroup(cellId: "SPTitleTestCCell", cellModelArray: ["1","2","3"])]),
         SPListingSection(
            CellGroups: [
               SPListingCellGroup(cellId: "SPTitleTestCCell", cellCount: 15, cellCommonModel: "12"),
               SPListingCellGroup(cellId: "SPTitleTestCCell", cellModelArray: ["1","2","3"])])])

      layout.prepareLayout()
      
      XCTAssert(true, "No Crash only SpeedKit Errors are expected")
   }
}


class SPTestFixedColumRowLayout : NSObject, SPFixedColumnRowLayoutDelegate{
   func noOfRows(ForSection section : Int) -> UInt{
      if section == 0 {
         return 3
      }
      return 4
   }
   
   func noOfColumns(ForSection section : Int) -> UInt{
      if section == 0 {
         return 4
      }
      return 3
   }
   
   ///Gets Line spacing required for that section.
   func lineSpacing(ForSection section : Int) -> CGFloat{
      if section == 0 {
         return 5
      }
      return 10
   }
   
   ///Gets Inter item spacing required for that section.
   func interItemSpacing(ForSection section : Int) -> CGFloat{
      if section == 0 {
         return 10
      }
      return 5
   }
   
   ///Gets Section Inset required for that section
   func sectionInset(ForSection section : Int) -> UIEdgeInsets{
      if section == 0 {
         return UIEdgeInsetsMake(10, 20, 30, 40)
      }
      return UIEdgeInsetsMake(40, 30, 20, 10)
      
   }

}
