//
//  SPCollectionViewDatasourceTests.swift
//  SwiftUIDemo
//
//  Created by Pradip Vaghasiya on 01/05/15.
//  Copyright (c) 2015 SpeedUI. All rights reserved.
//

import UIKit
import XCTest
import SwiftUI

class SPCollectionViewDatasourceTests: XCTestCase {
   
   class SPListingViewProtocolTestClass : SPListingViewProtocol{
      var spListingData : SPListingData = SPListingData(SectionArray: [])
   }
   
   var listingViewProtocolTestClass = SPListingViewProtocolTestClass()
   var listingViewProtocolTestClassWithOneSection = SPListingViewProtocolTestClass()
   var listingViewProtocolTestClassWithMultipleSection = SPListingViewProtocolTestClass()
   
   var collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: 100, height: 300), collectionViewLayout: SPListingColumnBasedLayout())
   
   var emptyDatasource = SPCollectionViewDataSource(SPListingViewProtocolTestClass())
   var oneSectionDatasource = SPCollectionViewDataSource(SPListingViewProtocolTestClass())
   var twoSectionDatasource = SPCollectionViewDataSource(SPListingViewProtocolTestClass())

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
      emptyDatasource = SPCollectionViewDataSource(listingViewProtocolTestClass)
      
      listingViewProtocolTestClassWithOneSection.spListingData.spListingSectionArray.append(SPListingSection(
         CellGroups: [
            SPListingCellGroup(cellId: "SPTitleTestCCell", cellCount: 12, cellCommonModel: SPTitleTestCCellCommonModel(TextAlignment: NSTextAlignment.Center)),
            SPListingCellGroup(cellId: "SPTitleTestCCell", cellModelArray: ["1","2","3"]),
            SPListingCellGroup(cellId: "SPTitleLabelCell", cellModelArray: ["1","2","3"])
         ]))
      oneSectionDatasource = SPCollectionViewDataSource(listingViewProtocolTestClassWithOneSection)
      
      listingViewProtocolTestClassWithMultipleSection.spListingData.spListingSectionArray.append(SPListingSection(
         CellGroups: [
            SPListingCellGroup(cellId: "SPTitleTestCCell", cellCount: 12, cellCommonModel: "CommonModel"),
            SPListingCellGroup(cellId: "SPTitleTestCCell", cellModelArray: ["1","2","3"], cellType : SPCellType.SubclassCell)
         ]))
      
      listingViewProtocolTestClassWithMultipleSection.spListingData.spListingSectionArray.append(SPListingSection(
         CellGroups: [
            SPListingCellGroup(cellId: "SwiftUIDemo.SPTitleTestCCell", cellModelArray: ["1","2","3"], cellType : SPCellType.SubclassCell),
            SPListingCellGroup(cellId: "UICollectionViewCell", cellModelArray: ["4","5","6"], cellType : SPCellType.SubclassCell)
         ]))
      
      listingViewProtocolTestClassWithMultipleSection.spListingData.spListingSectionArray.append(SPListingSection(
         CellGroups: [
            SPListingCellGroup(cellId: "InvalidPrototypeCell", cellModelArray: ["1","2","3"], cellType : SPCellType.PrototypeCell),
            SPListingCellGroup(cellId: "SPTitleTestCCell", cellModelArray: [SPTitleTestCCellModel(TitleText: "4")], cellType : SPCellType.PrototypeCell),
            SPListingCellGroup(cellId: "SPTitleTestCCell", cellCount: 12, cellCommonModel: SPTitleTestCCellCommonModel(TextAlignment: NSTextAlignment.Center), cellType : SPCellType.PrototypeCell)
            
         ]))
      
      twoSectionDatasource = SPCollectionViewDataSource(listingViewProtocolTestClassWithMultipleSection)

    }
    
    override func tearDown() {
      listingViewProtocolTestClass.spListingData = SPListingData(SectionArray: [])
      listingViewProtocolTestClassWithOneSection.spListingData = SPListingData(SectionArray: [])
      listingViewProtocolTestClassWithMultipleSection.spListingData = SPListingData(SectionArray: [])

        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

   func testNoOfSectionsWithEmptySectionArray(){
      XCTAssert(emptyDatasource.delegate.spListingData.sectionCount == 0, "Delegate should be created")
   }
   
   func testNoOfSectionsWithSectionArray(){
      XCTAssert(emptyDatasource.numberOfSectionsInCollectionView(collectionView) == 0 &&
         oneSectionDatasource.numberOfSectionsInCollectionView(collectionView) == 1 &&
         twoSectionDatasource.numberOfSectionsInCollectionView(collectionView) == 3, "Section count should be Valid")
   }
   
   func testNoOfRowsInSection(){
      XCTAssert(emptyDatasource.collectionView(collectionView, numberOfItemsInSection: 0) == 0 &&
         oneSectionDatasource.collectionView(collectionView, numberOfItemsInSection: 0) == 18 &&
         oneSectionDatasource.collectionView(collectionView, numberOfItemsInSection: 1) == 0 &&
         twoSectionDatasource.collectionView(collectionView, numberOfItemsInSection: 0) == 15 &&
         twoSectionDatasource.collectionView(collectionView, numberOfItemsInSection: 1) == 6 &&
         twoSectionDatasource.collectionView(collectionView, numberOfItemsInSection: 2) == 16, "Rows count should be valid")
   }
   
   
   func testCellAtIndexPathWithNilCellId(){
      let cell = twoSectionDatasource.collectionView(collectionView, cellForItemAtIndexPath: NSIndexPath(forRow: 12, inSection: 0))
      XCTAssertNotNil(cell, "Default Cell should be created using Nil Cell Id")
   }
   
   func testCellAtIndexPathWithInvalidCell(){
      collectionView.registerClass (NSClassFromString("UICollectionViewCell"), forCellWithReuseIdentifier: "UICollectionViewCell")
      collectionView.dataSource = twoSectionDatasource
      
      let cell = twoSectionDatasource.collectionView(collectionView, cellForItemAtIndexPath: NSIndexPath(forRow: 3, inSection: 1))
      XCTAssertNotNil(cell, "Default Cell should be created If not conform to SPListingViewProtocol")
   }
   
   func testCellAtIndexPathWithWrongTypeNibCell(){
//      collectionView.registerNib(UINib(nibName: "SPTitleLabelCell", bundle: nil), forCellWithReuseIdentifier: "SPTitleLabelCell")
//      collectionView.dataSource = oneSectionDatasource
//      
//      var cell = oneSectionDatasource.collectionView(collectionView, cellForItemAtIndexPath: NSIndexPath(forRow: 16, inSection: 0))
//      
//      XCTAssert(NSStringFromClass(cell.classForCoder) == "SwiftUIDemo.SPTitleTestCCell", "Nib Cell should not be created")

      ///TODO: No Try Catch in Swift: Uncomment above code, this will throw runtime exception. It tries to use nib file for which root object is not collectionviewcell

   }

   func testCellAtIndexPathWithNibCell(){
      collectionView.registerNib(UINib(nibName: "SPTitleTestCCell", bundle: nil), forCellWithReuseIdentifier: "SPTitleTestCCell")
      collectionView.dataSource = twoSectionDatasource
      
      let cell = twoSectionDatasource.collectionView(collectionView, cellForItemAtIndexPath: NSIndexPath(forRow: 0, inSection: 0))
      
      XCTAssert(NSStringFromClass(cell.classForCoder) == "SwiftUIDemo.SPTitleTestCCell", "Nib Cell should be created")
   }
   
   func testCellAtIndexPathWithoutRegisteringNib(){
//      var cell = twoSectionDatasource.collectionView(collectionView, cellForItemAtIndexPath: NSIndexPath(forRow: 0, inSection: 0))
//      
//      XCTAssertNotNil(cell, "Default Cell should be created.")
      
      ///TODO: No Try Catch in Swift: Collectionview dequeue run time crash
   }
      
   func testCellAtIndexPathWithSubClassCell(){
      collectionView.registerClass(NSClassFromString("SwiftUIDemo.SPTitleTestCCell"), forCellWithReuseIdentifier: "SwiftUIDemo.SPTitleTestCCell")
      collectionView.dataSource = twoSectionDatasource
      
      let cell = twoSectionDatasource.collectionView(collectionView, cellForItemAtIndexPath: NSIndexPath(forRow: 0, inSection: 1))
      
      XCTAssert(NSStringFromClass(cell.classForCoder) == "SwiftUIDemo.SPTitleTestCCell", "SubClass Cell should be created")
   }
   
   
   func testCellAtIndexPathWithoutRegisteringSubclass(){
//      var cell = twoSectionDatasource.collectionView(collectionView, cellForItemAtIndexPath: NSIndexPath(forRow: 0, inSection: 1))
//      
//      XCTAssertNotNil(cell, "Default Cell should be created.")
      
      ///TODO: No Try Catch in Swift: Collectionview dequeue run time crash

   }
   
   func testCellAtIndexPathWithPrototypeCell(){
     let storyboard = UIStoryboard(name: "SPTestStoryboard", bundle: NSBundle(forClass: self.classForCoder))
     let spCollectionViewTestVC : SPCollectionViewTestVC = (storyboard.instantiateViewControllerWithIdentifier("SPCollectionViewTestVC") as? SPCollectionViewTestVC)!
     
     spCollectionViewTestVC.view.setNeedsDisplay()
     spCollectionViewTestVC.collectionView.dataSource = twoSectionDatasource
     
     let cell = twoSectionDatasource.collectionView(spCollectionViewTestVC.collectionView, cellForItemAtIndexPath: NSIndexPath(forRow: 3, inSection: 2))
     
     XCTAssert(NSStringFromClass(cell.classForCoder) == "SpeedKitTests.SPTitleTestCCell", "Test Cell should be created")
      
   }
   
   func testCellAtIndexPathWithInvalidPrototypeCell(){
//      var cell = twoSectionDatasource.collectionView(collectionView, cellForItemAtIndexPath: NSIndexPath(forRow: 0, inSection: 2))
//      XCTAssertNotNil(cell, "Default Cell should be created.")

      ///TODO: No Try Catch in Swift: Collectionview dequeue run time crash

   }
   
   func testConfigureCellUsingCellModel(){
      let storyboard = UIStoryboard(name: "SPTestStoryboard", bundle: NSBundle(forClass: self.classForCoder))
      let spCollectionViewTestVC : SPCollectionViewTestVC = (storyboard.instantiateViewControllerWithIdentifier("SPCollectionViewTestVC") as? SPCollectionViewTestVC)!
      
      spCollectionViewTestVC.view.setNeedsDisplay()
      spCollectionViewTestVC.collectionView.dataSource = twoSectionDatasource
      
      let cell : SPTitleTestCCell? = twoSectionDatasource.collectionView(spCollectionViewTestVC.collectionView, cellForItemAtIndexPath: NSIndexPath(forRow: 3, inSection: 2)) as? SPTitleTestCCell
      
      
      XCTAssert(cell?.titleLabel?.text == "4", "Cell should be configured")
      
   }
   
   func testConfigureCellUsingCellCommonModel(){
      let storyboard = UIStoryboard(name: "SPTestStoryboard", bundle: NSBundle(forClass: self.classForCoder))
      let spCollectionViewTestVC : SPCollectionViewTestVC = (storyboard.instantiateViewControllerWithIdentifier("SPCollectionViewTestVC") as? SPCollectionViewTestVC)!
      
      spCollectionViewTestVC.view.setNeedsDisplay()
      spCollectionViewTestVC.collectionView.dataSource = twoSectionDatasource
      
      let cell : SPTitleTestCCell? = twoSectionDatasource.collectionView(spCollectionViewTestVC.collectionView, cellForItemAtIndexPath: NSIndexPath(forRow: 6, inSection: 2)) as? SPTitleTestCCell
      
      
      XCTAssert(cell?.titleLabel?.textAlignment == NSTextAlignment.Center, "Cell should be configured")
      
   }
   
}
