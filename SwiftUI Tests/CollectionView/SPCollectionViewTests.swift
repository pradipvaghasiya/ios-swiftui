//
//  SPCollectionViewTests.swift
//  SwiftUIDemo
//
//  Created by Pradip Vaghasiya on 01/05/15.
//  Copyright (c) 2015 SpeedUI. All rights reserved.
//

import UIKit
import XCTest
import SwiftUI

class SPCollectionViewTests: XCTestCase {

   var spCollectionView = SPCollectionView(frame: CGRect(x: 0, y: 0, width: 100, height: 300), collectionViewLayout: SPFixedColumnRowVerticalLayout())

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
      spCollectionView = SPCollectionView(frame: CGRect(x: 0, y: 0, width: 100, height: 300), collectionViewLayout: SPFixedColumnRowVerticalLayout())
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

   func testFromStoryboard(){
      let storyboard = UIStoryboard(name: "SPTestStoryboard", bundle: Bundle(for: self.classForCoder))
      let spCollectionViewTestVC : SPCollectionViewTestVC = (storyboard.instantiateViewController(withIdentifier: "SPCollectionViewTestVC") as? SPCollectionViewTestVC)!
      
      spCollectionViewTestVC.view.setNeedsDisplay()
      
      XCTAssertNotNil(spCollectionViewTestVC.spCollectionView.dataSource, "spCollectionView Datasource set")
      
   }
   
   func testFromCode(){
      XCTAssertNotNil(spCollectionView, "spCollectionView Created")
   }
   
   func testDatasourceNibsRegistered(){
      spCollectionView.spListingData = SPListingData(SectionArray: [SPListingSection(
         CellGroups: [
            SPListingCellGroup(cellId: "SPTitleTestCCell", cellCount: 12, cellCommonModel: "12"),
            SPListingCellGroup(cellId: "SPTitleTestCCell", cellModelArray: ["1","2","3"])])])
      
      XCTAssertNotNil(spCollectionView.dequeueReusableCellWithReuseIdentifier("SPTitleTestCCell", forIndexPath: IndexPath(forRow: 0, inSection: 0)), "Nib Registered")
   }
   
   func testDatasourceWrongTypeNibsRegistered(){
      spCollectionView.spListingData = SPListingData(SectionArray: [SPListingSection(
         CellGroups: [
            SPListingCellGroup(cellId: "SPTitleLabelCell", cellCount: 12, cellCommonModel: "12"),
            SPListingCellGroup(cellId: "SPTitleLabelCell", cellModelArray: ["1","2","3"])])])
      
//      XCTAssertNotNil(spCollectionView.dequeueReusableCellWithReuseIdentifier("SPTitleLabelCell", forIndexPath: NSIndexPath(forRow: 0, inSection: 0)), "Nib Registered")
      ///TODO: No Try Catch in Swift: Collectionview dequeue run time crash

   }

   
   func testDatasourceSubClassRegistered(){
      spCollectionView.spListingData = SPListingData(SectionArray: [SPListingSection(
         CellGroups: [
            SPListingCellGroup(cellId: "SPTitleTestCCell", cellCount: 12, cellCommonModel: "12"),
            SPListingCellGroup(cellId: "SwiftUIDemo.SPTitleTestCCell", cellModelArray: ["1","2","3"], cellType : SPCellType.SubclassCell)])])
      
      XCTAssertNotNil(spCollectionView.dequeueReusableCellWithReuseIdentifier("SwiftUIDemo.SPTitleTestCCell", forIndexPath: IndexPath(forRow: 12, inSection: 0)), "Subclass Registered")
   }
   
   func testDatasourceWrongTypeSubClassRegistered(){
      spCollectionView.spListingData = SPListingData(SectionArray: [SPListingSection(
         CellGroups: [
            SPListingCellGroup(cellId: "SPTitleLabelCell", cellCount: 12, cellCommonModel: "12"),
            SPListingCellGroup(cellId: "SwiftUIDemo.SPTitleLabelCell", cellModelArray: ["1","2","3"], cellType : SPCellType.SubclassCell)])])
      
//      XCTAssertNotNil(spCollectionView.dequeueReusableCellWithReuseIdentifier("SwiftUIDemo.SPTitleLabelCell", forIndexPath: NSIndexPath(forRow: 0, inSection: 0)), "Subclass Registered")
      ///TODO: No Try Catch in Swift: Collectionview dequeue run time crash

   }

   
   func testDatasourceDoesntRegisterCellsAfterUpdate(){
      spCollectionView.spListingData = SPListingData(SectionArray: [SPListingSection(
         CellGroups: [
            SPListingCellGroup(cellId: "SPTitleTestCCell", cellCount: 12, cellCommonModel: "12"),
            SPListingCellGroup(cellId: "SPTitleTestCCell", cellModelArray: ["1","2","3"])])])
      
      spCollectionView.spListingData.spListingSectionArray[0].spCellGroupArray.append(SPListingCellGroup(cellId: "SwiftUIDemo.SPTitleTestCCell", cellModelArray: ["1","2","3"], cellType : SPCellType.SubclassCell))
      
//      XCTAssertNil(spCollectionView.dequeueReusableCellWithReuseIdentifier("SwiftUIDemo.SPTitleTestCCell", forIndexPath: NSIndexPath(forRow: 0, inSection: 0)), "Subclass should not be Registered")
      ///TODO: No Try Catch in Swift: Collectionview dequeue run time crash

   }
   
   func testRegisterCellsAfterUpdate(){
      spCollectionView.spListingData = SPListingData(SectionArray: [SPListingSection(
         CellGroups: [
            SPListingCellGroup(cellId: "SPTitleTestCCell", cellCount: 12, cellCommonModel: "12"),
            SPListingCellGroup(cellId: "SPTitleTestCCell", cellModelArray: ["1","2","3"])])])
      
      let cellGroup = SPListingCellGroup(cellId: "SwiftUIDemo.SPTitleTestCCell", cellModelArray: ["1","2","3"], cellType : SPCellType.SubclassCell)
      spCollectionView.spListingData.spListingSectionArray[0].spCellGroupArray.append(cellGroup)
      
      spCollectionView.registerCellsFor(CellGroup: cellGroup)
      
      XCTAssertNotNil(spCollectionView.dequeueReusableCellWithReuseIdentifier("SwiftUIDemo.SPTitleTestCCell", forIndexPath: IndexPath(forRow: 0, inSection: 0)), "Subclass should not be Registered")
   }
   
   func testDatasourceDoesntRegisterCellsAfterFullUpdate(){
      spCollectionView.spListingData = SPListingData(SectionArray: [SPListingSection(
         CellGroups: [
            SPListingCellGroup(cellId: "SPTitleTestCCell", cellCount: 12, cellCommonModel: "12"),
            SPListingCellGroup(cellId: "SPTitleTestCCell", cellModelArray: ["1","2","3"])])])
      
      spCollectionView.spListingData = SPListingData(SectionArray: [SPListingSection(
         CellGroups: [
            SPListingCellGroup(cellId: "SPTitleTestCCell", cellCount: 12, cellCommonModel: "12"),
            SPListingCellGroup(cellId: "SwiftUIDemo.SPTitleTestCCell", cellModelArray: ["1","2","3"], cellType : SPCellType.SubclassCell)])])
      
//      XCTAssertNil(spCollectionView.dequeueReusableCellWithReuseIdentifier("SwiftUIDemo.SPTitleTestCCell", forIndexPath: NSIndexPath(forRow: 0, inSection: 0)), "Subclass should not be Registered")
      ///TODO: No Try Catch in Swift: Collectionview dequeue run time crash

   }
   
   func testRegisterCellsAfterFullUpdate(){
      spCollectionView.spListingData = SPListingData(SectionArray: [SPListingSection(
         CellGroups: [
            SPListingCellGroup(cellId: "SPTitleTestCCell", cellCount: 12, cellCommonModel: "12"),
            SPListingCellGroup(cellId: "SPTitleTestCCell", cellModelArray: ["1","2","3"])])])
      
      spCollectionView.spListingData = SPListingData(SectionArray: [SPListingSection(
         CellGroups: [
            SPListingCellGroup(cellId: "SPTitleTestCCell", cellCount: 12, cellCommonModel: "12"),
            SPListingCellGroup(cellId: "SwiftUIDemo.SPTitleTestCCell", cellModelArray: ["1","2","3"], cellType : SPCellType.SubclassCell)])])
      
      spCollectionView.registerReusableCellsIfRequired()
      
      XCTAssertNotNil(spCollectionView.dequeueReusableCellWithReuseIdentifier("SwiftUIDemo.SPTitleTestCCell", forIndexPath: IndexPath(forRow: 0, inSection: 0)), "Subclass should not be Registered")
   }


}
