//
//  SPTableViewDataSourceTests.swift
//  SwiftUIDemo
//
//  Created by Pradip Vaghasiya on 25/04/15.
//  Copyright (c) 2015 SpeedUI. All rights reserved.
//

import UIKit
import XCTest
import SwiftUIDemo

class SPTableViewDataSourceTests: XCTestCase {
   
   class SPListingViewProtocolTestClass : SPListingViewProtocol{
      var spListingData : SPListingData = SPListingData(SectionArray: [])
   }
   
   var listingViewProtocolTestClass = SPListingViewProtocolTestClass()
   var listingViewProtocolTestClassWithOneSection = SPListingViewProtocolTestClass()
   var listingViewProtocolTestClassWithMultipleSection = SPListingViewProtocolTestClass()

   
   var emptyDatasource = SPTableViewDatasource(SPListingViewProtocolTestClass())
   var oneSectionDatasource = SPTableViewDatasource(SPListingViewProtocolTestClass())
   var twoSectionDatasource = SPTableViewDatasource(SPListingViewProtocolTestClass())
   
   override func setUp() {
      super.setUp()
      // Put setup code here. This method is called before the invocation of each test method in the class.
      emptyDatasource = SPTableViewDatasource(listingViewProtocolTestClass)

      listingViewProtocolTestClassWithOneSection.spListingData.spListingSectionArray.append(ListingSection(
         CellGroups: [
            SPListingCellGroup(cellId: "SPTitleLabelCell", cellCount: 12, cellCommonModel: SPTitleLabelCellCommonModel(TextAlignment: NSTextAlignment.Center)),
            SPListingCellGroup(cellId: "SPTitleLabelCell", cellModelArray: ["1","2","3"]),
            SPListingCellGroup(cellId: "SPTitleTestCCell", cellModelArray: ["1","2","3"])
         ]))
      oneSectionDatasource = SPTableViewDatasource(listingViewProtocolTestClassWithOneSection)
      
      listingViewProtocolTestClassWithMultipleSection.spListingData.spListingSectionArray.append(ListingSection(
         CellGroups: [
            SPListingCellGroup(cellId: "SPTitleLabelCell", cellCount: 12, cellCommonModel: "CommonModel"),
            SPListingCellGroup(cellId: "SPTitleLabelCell", cellModelArray: ["1","2","3"], cellType : SPCellType.SubclassCell)
         ],SectionHeader : "Header",SectionFooter: "Footer"))

      listingViewProtocolTestClassWithMultipleSection.spListingData.spListingSectionArray.append(ListingSection(
         CellGroups: [
            SPListingCellGroup(cellId: "SwiftUIDemo.SPTitleLabelCell", cellModelArray: ["1","2","3"], cellType : SPCellType.SubclassCell),
            SPListingCellGroup(cellId: "UITableViewCell", cellModelArray: ["4","5","6"], cellType : SPCellType.SubclassCell)
         ]))
      
      listingViewProtocolTestClassWithMultipleSection.spListingData.spListingSectionArray.append(ListingSection(
         CellGroups: [
            SPListingCellGroup(cellId: "InvalidPrototypeCell", cellModelArray: ["1","2","3"], cellType : SPCellType.PrototypeCell),
            SPListingCellGroup(cellId: "SPTitleTestCell", cellModelArray: [SPTitleTestCellModel(TitleText: "4")], cellType : SPCellType.PrototypeCell),
            SPListingCellGroup(cellId: "SPTitleTestCell", cellCount: 12, cellCommonModel: SPTitleTestCellCommonModel(TextAlignment: NSTextAlignment.Center), cellType : SPCellType.PrototypeCell)

         ]))

      twoSectionDatasource = SPTableViewDatasource(listingViewProtocolTestClassWithMultipleSection)

   }
   
   override func tearDown() {
      
      listingViewProtocolTestClass.spListingData = SPListingData(SectionArray: [])
      listingViewProtocolTestClassWithOneSection.spListingData = SPListingData(SectionArray: [])
      listingViewProtocolTestClassWithMultipleSection.spListingData = SPListingData(SectionArray: [])
      
      // Put teardown code here. This method is called after the invocation of each test method in the class.
      super.tearDown()
      
   }
   
   // MARK: Init Test Cases
   func testNoOfSectionsWithEmptySectionArray(){
      
      XCTAssert(emptyDatasource.delegate.spListingData.sectionCount == 0, "Delegate should be created")
   }
   
   func testNoOfSectionsWithSectionArray(){
      XCTAssert(emptyDatasource.numberOfSectionsInTableView(UITableView()) == 0 &&
         oneSectionDatasource.numberOfSectionsInTableView(UITableView()) == 1 &&
         twoSectionDatasource.numberOfSectionsInTableView(UITableView()) == 3, "Section count should be Valid")
   }
   
   func testNoOfRowsInSection(){
      XCTAssert(emptyDatasource.tableView(UITableView(), numberOfRowsInSection: 0) == 0 &&
         oneSectionDatasource.tableView(UITableView(), numberOfRowsInSection: 0) == 18 &&
         oneSectionDatasource.tableView(UITableView(), numberOfRowsInSection: 1) == 0 &&
         twoSectionDatasource.tableView(UITableView(), numberOfRowsInSection: 0) == 15 &&
         twoSectionDatasource.tableView(UITableView(), numberOfRowsInSection: 1) == 6 &&
         twoSectionDatasource.tableView(UITableView(), numberOfRowsInSection: 2) == 16, "Rows count should be valid")
   }
   
   
   func testCellAtIndexPathWithNilCellId(){
      let cell = twoSectionDatasource.tableView(UITableView(), cellForRowAtIndexPath: NSIndexPath(forRow: 12, inSection: 0))
      XCTAssertNotNil(cell, "Default Cell should be created using Nil Cell Id")
   }
   
   func testCellAtIndexPathWithInvalidCell(){
      let tableView = UITableView()
      tableView.registerClass(NSClassFromString("UITableViewCell"), forCellReuseIdentifier: "UITableViewCell")
      tableView.dataSource = twoSectionDatasource
      
      let cell = twoSectionDatasource.tableView(tableView, cellForRowAtIndexPath: NSIndexPath(forRow: 3, inSection: 1))
      XCTAssertNotNil(cell, "Default Cell should be created If not conform to SPListingViewProtocol")
   }

   func testCellAtIndexPathWithWrongTypeNibCell(){
//      var tableView = UITableView()
//      tableView.registerNib(UINib(nibName: "SPTitleTestCCell", bundle: nil), forCellReuseIdentifier: "SPTitleTestCCell")
//      tableView.dataSource = oneSectionDatasource
//      
//      var cell = oneSectionDatasource.tableView(tableView, cellForRowAtIndexPath: NSIndexPath(forRow: 16, inSection: 0))
//      
//      XCTAssert(NSStringFromClass(cell.classForCoder) == "SwiftUIDemo.SPTitleTestCCell", "Nib Cell should not be created")
      
      ///TODO: No Try Catch in Swift: Uncomment above code, this will throw runtime exception. It tries to use nib file for which root object is not tableviewcell
   }

   func testCellAtIndexPathWithNibCell(){
      let tableView = UITableView()
      tableView.registerNib(UINib(nibName: "SPTitleLabelCell", bundle: nil), forCellReuseIdentifier: "SPTitleLabelCell")
      tableView.dataSource = twoSectionDatasource
      
      let cell = twoSectionDatasource.tableView(tableView, cellForRowAtIndexPath: NSIndexPath(forRow: 0, inSection: 0))
      
      XCTAssert(NSStringFromClass(cell.classForCoder) == "SwiftUIDemo.SPTitleLabelCell", "Nib Cell should be created")
   }
   
   func testCellAtIndexPathWithoutRegisteringNib(){
      let cell = twoSectionDatasource.tableView(UITableView(), cellForRowAtIndexPath: NSIndexPath(forRow: 0, inSection: 0))
      
      XCTAssertNotNil(cell, "Default Cell should be created.")
   }
   
   
   func testCellAtIndexPathWithSubClassCell(){
      let tableView = UITableView()
      tableView.registerClass(NSClassFromString("SwiftUIDemo.SPTitleLabelCell"), forCellReuseIdentifier: "SwiftUIDemo.SPTitleLabelCell")
      tableView.dataSource = twoSectionDatasource
      
      let cell = twoSectionDatasource.tableView(tableView, cellForRowAtIndexPath: NSIndexPath(forRow: 0, inSection: 1))
      
      XCTAssert(NSStringFromClass(cell.classForCoder) == "SwiftUIDemo.SPTitleLabelCell", "SubClass Cell should be created")
   }
   
   
   func testCellAtIndexPathWithoutRegisteringSubclass(){
      let cell = twoSectionDatasource.tableView(UITableView(), cellForRowAtIndexPath: NSIndexPath(forRow: 0, inSection: 1))
      
      XCTAssertNotNil(cell, "Default Cell should be created.")
   }
   
   func testCellAtIndexPathWithPrototypeCell(){
      let storyboard = UIStoryboard(name: "SPTestStoryboard", bundle: NSBundle(forClass: self.classForCoder))
      let spTableViewTestVC : SPTableViewTestVC = (storyboard.instantiateViewControllerWithIdentifier("SPTableViewTestVC") as? SPTableViewTestVC)!
      
      spTableViewTestVC.view.setNeedsDisplay()
      spTableViewTestVC.tableView.dataSource = twoSectionDatasource

      let cell = twoSectionDatasource.tableView(spTableViewTestVC.tableView, cellForRowAtIndexPath: NSIndexPath(forRow: 3, inSection: 2))

      XCTAssert(NSStringFromClass(cell.classForCoder) == "SwiftUITests.SPTitleTestCell", "Test Cell should be created")
      
   }
   
   func testCellAtIndexPathWithInvalidPrototypeCell(){
      let cell = twoSectionDatasource.tableView(UITableView(), cellForRowAtIndexPath: NSIndexPath(forRow: 0, inSection: 2))
      XCTAssertNotNil(cell, "Default Cell should be created.")
   }
   
   func testConfigureCellUsingCellModel(){
      let storyboard = UIStoryboard(name: "SPTestStoryboard", bundle: NSBundle(forClass: self.classForCoder))
      let spTableViewTestVC : SPTableViewTestVC = (storyboard.instantiateViewControllerWithIdentifier("SPTableViewTestVC") as? SPTableViewTestVC)!
      
      spTableViewTestVC.view.setNeedsDisplay()
      spTableViewTestVC.tableView.dataSource = twoSectionDatasource
      
      let cell : SPTitleTestCell? = twoSectionDatasource.tableView(spTableViewTestVC.tableView, cellForRowAtIndexPath: NSIndexPath(forRow: 3, inSection: 2)) as? SPTitleTestCell
      
      
      XCTAssert(cell?.titleLabel?.text == "4", "Cell should be configured")

   }
   
   func testConfigureCellUsingCellCommonModel(){
      let storyboard = UIStoryboard(name: "SPTestStoryboard", bundle: NSBundle(forClass: self.classForCoder))
      let spTableViewTestVC : SPTableViewTestVC = (storyboard.instantiateViewControllerWithIdentifier("SPTableViewTestVC") as? SPTableViewTestVC)!
      
      spTableViewTestVC.view.setNeedsDisplay()
      spTableViewTestVC.tableView.dataSource = twoSectionDatasource
      
      let cell : SPTitleTestCell? = twoSectionDatasource.tableView(spTableViewTestVC.tableView, cellForRowAtIndexPath: NSIndexPath(forRow: 6, inSection: 2)) as? SPTitleTestCell
      
      
      XCTAssert(cell?.titleLabel?.textAlignment == NSTextAlignment.Center, "Cell should be configured")
      
   }

   func testTableViewHeaderAndFooterSet(){
      let storyboard = UIStoryboard(name: "SPTestStoryboard", bundle: NSBundle(forClass: self.classForCoder))
      let spTableViewTestVC : SPTableViewTestVC = (storyboard.instantiateViewControllerWithIdentifier("SPTableViewTestVC") as? SPTableViewTestVC)!
      
      spTableViewTestVC.view.setNeedsDisplay()
      spTableViewTestVC.tableView.dataSource = twoSectionDatasource
      
      XCTAssert(twoSectionDatasource.tableView(spTableViewTestVC.tableView, titleForHeaderInSection: 0) == "Header" &&
         twoSectionDatasource.tableView(spTableViewTestVC.tableView, titleForFooterInSection: 0) == "Footer", "Header and Footer should be set")
      
   }
   

}
