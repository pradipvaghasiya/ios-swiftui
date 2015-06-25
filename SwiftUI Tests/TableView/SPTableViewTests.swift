//
//  SPTableViewTests.swift
//  SwiftUIDemo
//
//  Created by Pradip Vaghasiya on 29/04/15.
//  Copyright (c) 2015 SpeedUI. All rights reserved.
//

import UIKit
import XCTest

class SPTableViewTests: XCTestCase {
   
   var spTableView = SPTableView(frame: CGRect(x: 0, y: 0, width: 100, height: 100), style: .Plain)
   
   override func setUp() {
      super.setUp()
      // Put setup code here. This method is called before the invocation of each test method in the class.
      
      spTableView = SPTableView(frame: CGRect(x: 0, y: 0, width: 100, height: 100), style: .Plain)
   }
   
   override func tearDown() {
      // Put teardown code here. This method is called after the invocation of each test method in the class.
      super.tearDown()
      
   }
   
   func testFromStoryboard(){
      let storyboard = UIStoryboard(name: "SPTestStoryboard", bundle: NSBundle(forClass: self.classForCoder))
      let spTableViewTestVC : SPTableViewTestVC = (storyboard.instantiateViewControllerWithIdentifier("SPTableViewTestVC") as? SPTableViewTestVC)!
      
      spTableViewTestVC.view.setNeedsDisplay()
      
      XCTAssertNotNil(spTableViewTestVC.spTableView.dataSource, "SPTableView Datasource set")
      
   }
   
   func testFromCode(){
      XCTAssertNotNil(spTableView, "SPTableView Created")
   }
   
   func testDatasourceNibsRegistered(){
      spTableView.spListingData = SPListingData(SectionArray: [SPListingSection(
         CellGroups: [
            SPListingCellGroup(cellId: "SPTitleLabelCell", cellCount: 12, cellCommonModel: "12"),
            SPListingCellGroup(cellId: "SPTitleLabelCell", cellModelArray: ["1","2","3"])])])
      
      XCTAssertNotNil(spTableView.dequeueReusableCellWithIdentifier("SPTitleLabelCell"), "Nib Registered")
   }
   
   func testDatasourceWrongTypeNibsRegistered(){
      spTableView.spListingData = SPListingData(SectionArray: [SPListingSection(
         CellGroups: [
            SPListingCellGroup(cellId: "SPTitleTestCCell", cellCount: 12, cellCommonModel: "12"),
            SPListingCellGroup(cellId: "SPTitleTestCCell", cellModelArray: ["1","2","3"])])])
      
//      XCTAssertNil(spTableView.dequeueReusableCellWithIdentifier("SPTitleTestCCell"), "Nib should not Registered")
      ///TODO: No Try Catch in swift: spTableView.dequeueReusableCellWithIdentifier run time crash.
   }
   
   func testDatasourceWrongTypeSubClassRegistered(){
      spTableView.spListingData = SPListingData(SectionArray: [SPListingSection(
         CellGroups: [
            SPListingCellGroup(cellId: "SPTitleTestCCell", cellCount: 12, cellCommonModel: "12"),
            SPListingCellGroup(cellId: "SwiftUIDemo.SPTitleTestCCell", cellModelArray: ["1","2","3"], cellType : SPCellType.SubclassCell)])])
      
      XCTAssertNil(spTableView.dequeueReusableCellWithIdentifier("SwiftUIDemo.SPTitleTestCCell"), "Subclass should not be Registered")
   }
   
   func testDatasourceSubClassRegistered(){
      spTableView.spListingData = SPListingData(SectionArray: [SPListingSection(
         CellGroups: [
            SPListingCellGroup(cellId: "SPTitleLabelCell", cellCount: 12, cellCommonModel: "12"),
            SPListingCellGroup(cellId: "SwiftUIDemo.SPTitleLabelCell", cellModelArray: ["1","2","3"], cellType : SPCellType.SubclassCell)])])
      
      XCTAssertNotNil(spTableView.dequeueReusableCellWithIdentifier("SwiftUIDemo.SPTitleLabelCell"), "Subclass Registered")
   }
   
   func testDatasourceDoesntRegisterCellsAfterUpdate(){
      spTableView.spListingData = SPListingData(SectionArray: [SPListingSection(
         CellGroups: [
            SPListingCellGroup(cellId: "SPTitleLabelCell", cellCount: 12, cellCommonModel: "12"),
            SPListingCellGroup(cellId: "SPTitleLabelCell", cellModelArray: ["1","2","3"])])])
      
      spTableView.spListingData.spListingSectionArray[0].spCellGroupArray.append(SPListingCellGroup(cellId: "SwiftUIDemo.SPTitleLabelCell", cellModelArray: ["1","2","3"], cellType : SPCellType.SubclassCell))
      
      XCTAssertNil(spTableView.dequeueReusableCellWithIdentifier("SwiftUIDemo.SPTitleLabelCell"), "Subclass should not be Registered")
   }
   
   func testRegisterCellsAfterUpdate(){
      spTableView.spListingData = SPListingData(SectionArray: [SPListingSection(
         CellGroups: [
            SPListingCellGroup(cellId: "SPTitleLabelCell", cellCount: 12, cellCommonModel: "12"),
            SPListingCellGroup(cellId: "SPTitleLabelCell", cellModelArray: ["1","2","3"])])])
      
      var cellGroup = SPListingCellGroup(cellId: "SwiftUIDemo.SPTitleLabelCell", cellModelArray: ["1","2","3"], cellType : SPCellType.SubclassCell)
      spTableView.spListingData.spListingSectionArray[0].spCellGroupArray.append(cellGroup)
      
      spTableView.registerCellsFor(CellGroup: cellGroup)
      
      XCTAssertNotNil(spTableView.dequeueReusableCellWithIdentifier("SwiftUIDemo.SPTitleLabelCell"), "Subclass should not be Registered")
   }

   func testDatasourceDoesntRegisterCellsAfterFullUpdate(){
      spTableView.spListingData = SPListingData(SectionArray: [SPListingSection(
         CellGroups: [
            SPListingCellGroup(cellId: "SPTitleLabelCell", cellCount: 12, cellCommonModel: "12"),
            SPListingCellGroup(cellId: "SPTitleLabelCell", cellModelArray: ["1","2","3"])])])
      
      spTableView.spListingData = SPListingData(SectionArray: [SPListingSection(
         CellGroups: [
            SPListingCellGroup(cellId: "SPTitleLabelCell", cellCount: 12, cellCommonModel: "12"),
            SPListingCellGroup(cellId: "SwiftUIDemo.SPTitleLabelCell", cellModelArray: ["1","2","3"], cellType : SPCellType.SubclassCell)])])
      
      XCTAssertNil(spTableView.dequeueReusableCellWithIdentifier("SwiftUIDemo.SPTitleLabelCell"), "Subclass should not be Registered")
   }
   
   func testRegisterCellsAfterFullUpdate(){
      spTableView.spListingData = SPListingData(SectionArray: [SPListingSection(
         CellGroups: [
            SPListingCellGroup(cellId: "SPTitleLabelCell", cellCount: 12, cellCommonModel: "12"),
            SPListingCellGroup(cellId: "SPTitleLabelCell", cellModelArray: ["1","2","3"])])])
      
      spTableView.spListingData = SPListingData(SectionArray: [SPListingSection(
         CellGroups: [
            SPListingCellGroup(cellId: "SPTitleLabelCell", cellCount: 12, cellCommonModel: "12"),
            SPListingCellGroup(cellId: "SwiftUIDemo.SPTitleLabelCell", cellModelArray: ["1","2","3"], cellType : SPCellType.SubclassCell)])])
      
      spTableView.registerReusableCellsIfRequired()
      
      XCTAssertNotNil(spTableView.dequeueReusableCellWithIdentifier("SwiftUIDemo.SPTitleLabelCell"), "Subclass should not be Registered")
   }


   
}
