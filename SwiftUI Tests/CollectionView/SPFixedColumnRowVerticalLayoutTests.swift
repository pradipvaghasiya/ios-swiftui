//
//  SPFixedColumnRowVerticalLayoutTests.swift
//  SwiftUIDemo
//
//  Created by Pradip Vaghasiya on 01/05/15.
//  Copyright (c) 2015 SpeedUI. All rights reserved.
//

import UIKit
import XCTest

class SPFixedColumnRowVerticalLayoutTests: XCTestCase {
   
   var layout = SPFixedColumnRowVerticalLayout(NoOfRows: 4, NoOfColumns: 3)
   var spCollectionViewTestVC : SPCollectionViewTestVC?
   fileprivate var delegate = SPTestFixedColumRowLayout()
   
   override func setUp() {
      super.setUp()
      // Put setup code here. This method is called before the invocation of each test method in the class.
      
      layout = SPFixedColumnRowVerticalLayout(NoOfRows: 3, NoOfColumns: 3)
      
      let storyboard = UIStoryboard(name: "SPTestStoryboard", bundle: Bundle(for: self.classForCoder))
      spCollectionViewTestVC = (storyboard.instantiateViewController(withIdentifier: "SPCollectionViewTestVC") as? SPCollectionViewTestVC)!
      spCollectionViewTestVC!.view.setNeedsDisplay()
      spCollectionViewTestVC!.spCollectionView.collectionViewLayout = layout
      layout.delegate = delegate
   }
   
   override func tearDown() {
      // Put teardown code here. This method is called after the invocation of each test method in the class.
      super.tearDown()
   }
   
   func testEmptyCreation(){
      layout = SPFixedColumnRowVerticalLayout()
      XCTAssert(layout.noOfRows == 3 &&
         layout.noOfColumns == 3, "Layout should be Created")
   }

   func testLayoutCreation() {
      // This is an example of a functional test case.
      XCTAssert(layout.noOfColumns == 3 &&
         layout.noOfRows == 3, "Pass")
   }
   
   func testAttributeCalculationWithCollectionViewNil(){
      let layout1 = SPFixedColumnRowVerticalLayout(NoOfRows: 10, NoOfColumns: 10)
      
      layout1.prepareLayout()
      
      XCTAssert(layout1.attributesDictionary.count == 0 &&
         layout1.sectionSizeDictionary.count == 0, "CollectionView as nil")
   }
   
   func testAttributeCalculationWithNoSections(){
      layout.prepareLayout()
      XCTAssert(layout.attributesDictionary.count == 0 &&
         layout.sectionSizeDictionary.count == 0, "CollectionView No Section")
   }
   
   func testSizeWithSectionDetails(){
      spCollectionViewTestVC!.spCollectionView.spListingData = SPListingData(SectionArray: [SPListingSection(
         CellGroups: [
            SPListingCellGroup(cellId: "SPTitleTestCCell", cellCount: 15, cellCommonModel: "12"),
            SPListingCellGroup(cellId: "SPTitleTestCCell", cellModelArray: ["1","2","3"])]),
         SPListingSection(
            CellGroups: [
               SPListingCellGroup(cellId: "SPTitleTestCCell", cellCount: 15, cellCommonModel: "12"),
               SPListingCellGroup(cellId: "SPTitleTestCCell", cellModelArray: ["1","2","3"])])])
      
      spCollectionViewTestVC!.spCollectionView.contentInset = UIEdgeInsetsMake(30, 40, 50, 60)

      layout.prepareLayout()
      
      print(spCollectionViewTestVC!.spCollectionView.bounds)
      for (indexPath,attr) in layout.attributesDictionary{
         print("\(indexPath.row) : \(indexPath.section) - \(attr.frame) ")
      }

      XCTAssert(layout.attributesDictionary[IndexPath(forRow: 0, inSection: 0)]?.frame.size.width == 102.5 &&
         layout.attributesDictionary[IndexPath(forRow: 0, inSection: 0)]?.frame.size.height == 156.67 &&
         layout.attributesDictionary[IndexPath(forRow: 0, inSection: 1)]?.frame.size.width == 150.0 &&
         layout.attributesDictionary[IndexPath(forRow: 0, inSection: 1)]?.frame.size.height == 107.5, "Height and Width should be valid")
   }
   
   func testEmptyPrepareLayout(){
      spCollectionViewTestVC!.spCollectionView.spListingData = SPListingData(SectionArray: [SPListingSection(
         CellGroups: [
            SPListingCellGroup(cellId: "SPTitleTestCCell", cellCount: 15, cellCommonModel: "12"),
            SPListingCellGroup(cellId: "SPTitleTestCCell", cellModelArray: ["1","2","3"])]),
         SPListingSection(
            CellGroups: [
               SPListingCellGroup(cellId: "SPTitleTestCCell", cellCount: 15, cellCommonModel: "12"),
               SPListingCellGroup(cellId: "SPTitleTestCCell", cellModelArray: ["1","2","3"])])])
      
      spCollectionViewTestVC!.spCollectionView.contentInset = UIEdgeInsetsMake(30, 40, 50, 60)
      
      layout.prepareLayout()
      
      spCollectionViewTestVC!.spCollectionView.spListingData = SPListingData(SectionArray: [])
      spCollectionViewTestVC!.spCollectionView.dataSource = nil
      layout.prepareLayout()

      XCTAssert(layout.itemWidthHeightDictionary.count == 0, "itemWidthHeightDictionary should be reset.")
   }

   
   func testOriginWithSectionDetails(){
      spCollectionViewTestVC!.spCollectionView.spListingData = SPListingData(SectionArray: [SPListingSection(
         CellGroups: [
            SPListingCellGroup(cellId: "SPTitleTestCCell", cellCount: 15, cellCommonModel: "12"),
            SPListingCellGroup(cellId: "SPTitleTestCCell", cellModelArray: ["1","2","3"])]),
         SPListingSection(
            CellGroups: [
               SPListingCellGroup(cellId: "SPTitleTestCCell", cellCount: 15, cellCommonModel: "12"),
               SPListingCellGroup(cellId: "SPTitleTestCCell", cellModelArray: ["1","2","3"])])])
      
      spCollectionViewTestVC!.spCollectionView.contentInset = UIEdgeInsetsMake(30, 40, 50, 60)
      
      layout.prepareLayout()
      
//      for (indexPath,attr) in layout.attributesDictionary{
//         println("\(indexPath.row) : \(indexPath.section) - \(attr.frame) ")
//      }
      
      XCTAssert(layout.attributesDictionary[IndexPath(forRow: 0, inSection: 0)]?.frame.origin.x == 20.0 &&
         layout.attributesDictionary[IndexPath(forRow: 0, inSection: 0)]?.frame.origin.y == 10.0 &&
         layout.attributesDictionary[IndexPath(forRow: 2, inSection: 0)]?.frame.origin.x == 245.0 &&
         layout.attributesDictionary[IndexPath(forRow: 2, inSection: 0)]?.frame.origin.y == 10.0 &&
         layout.attributesDictionary[IndexPath(forRow: 4, inSection: 0)]?.frame.origin.x == 20.0 &&
         layout.attributesDictionary[IndexPath(forRow: 4, inSection: 0)]?.frame.origin.y == 171.67 &&
         layout.attributesDictionary[IndexPath(forRow: 5, inSection: 0)]?.frame.origin.x == 132.5 &&
         layout.attributesDictionary[IndexPath(forRow: 5, inSection: 0)]?.frame.origin.y == 171.67 &&
         layout.attributesDictionary[IndexPath(forRow: 0, inSection: 1)]?.frame.origin.x == 30.0 &&
         layout.attributesDictionary[IndexPath(forRow: 0, inSection: 1)]?.frame.origin.y == 883.35 &&
         layout.attributesDictionary[IndexPath(forRow: 3, inSection: 1)]?.frame.origin.x == 30.0 &&
         layout.attributesDictionary[IndexPath(forRow: 3, inSection: 1)]?.frame.origin.y == 1000.85 &&
         layout.attributesDictionary[IndexPath(forRow: 4, inSection: 1)]?.frame.origin.x == 185.0 &&
         layout.attributesDictionary[IndexPath(forRow: 4, inSection: 1)]?.frame.origin.y == 1000.85 , "Height and Width should be valid")
   }
   
   
   func testAttributeCalculationWithSectionDetailsAndSomeEmptySection(){
      spCollectionViewTestVC!.spCollectionView.spListingData = SPListingData(SectionArray: [SPListingSection(
         CellGroups: [
            SPListingCellGroup(cellId: "SPTitleTestCCell", cellCount: 15, cellCommonModel: "12"),
            SPListingCellGroup(cellId: "SPTitleTestCCell", cellModelArray: ["1","2","3"])]),
         SPListingSection(
            CellGroups: [
               SPListingCellGroup(cellId: "SPTitleTestCCell", cellCount: 15, cellCommonModel: "12"),
               SPListingCellGroup(cellId: "SPTitleTestCCell", cellModelArray: ["1","2","3"])])])
      
      layout.prepareLayout()

   }
   
   func testTotalCountForAttributesDictionary(){
      spCollectionViewTestVC!.spCollectionView.spListingData = SPListingData(SectionArray: [SPListingSection(
         CellGroups: []),
         SPListingSection(
            CellGroups: [
               SPListingCellGroup(cellId: "SPTitleTestCCell", cellCount: 15, cellCommonModel: "12"),
               SPListingCellGroup(cellId: "SPTitleTestCCell", cellModelArray: ["1","2","3"])])])
      
      layout.prepareLayout()
      
      XCTAssert(true, "No Run time error in case of empty section")

   }
   
   func testTotalCountForSectionSizeDictionary(){
      spCollectionViewTestVC!.spCollectionView.spListingData = SPListingData(SectionArray: [SPListingSection(
         CellGroups: [
            SPListingCellGroup(cellId: "SPTitleTestCCell", cellCount: 15, cellCommonModel: "12"),
            SPListingCellGroup(cellId: "SPTitleTestCCell", cellModelArray: ["1","2","3"])]),
         SPListingSection(
            CellGroups: [
               SPListingCellGroup(cellId: "SPTitleTestCCell", cellCount: 15, cellCommonModel: "12"),
               SPListingCellGroup(cellId: "SPTitleTestCCell", cellModelArray: ["1","2","3"])])])
      
      layout.prepareLayout()
      
      XCTAssert(layout.sectionSizeDictionary.count == 2, "Proper sectionSizeDictionary should be created")

   }
   
   func testCollectionViewContentSize(){
      spCollectionViewTestVC!.spCollectionView.spListingData = SPListingData(SectionArray: [SPListingSection(
         CellGroups: []),
         SPListingSection(
            CellGroups: [
               SPListingCellGroup(cellId: "SPTitleTestCCell", cellCount: 15, cellCommonModel: "12"),
               SPListingCellGroup(cellId: "SPTitleTestCCell", cellModelArray: ["1","2","3"])])])

      layout.prepareLayout()
      XCTAssert(layout.collectionViewContentSize().width == 600.0 &&
      layout.collectionViewContentSize().height == 835.0, "Content size should be valid.")
   }

}
