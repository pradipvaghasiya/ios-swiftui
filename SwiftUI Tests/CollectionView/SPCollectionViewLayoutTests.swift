//
//  SPCollectionViewLayoutTests.swift
//  SwiftUIDemo
//
//  Created by Pradip Vaghasiya on 01/05/15.
//  Copyright (c) 2015 SpeedUI. All rights reserved.
//

import UIKit
import XCTest
import SwiftUI

class SPCollectionViewLayoutTests: XCTestCase {
   fileprivate var layout = SPCollectionViewLayout()
   fileprivate var delegate = SPTestLayout()
   
   override func setUp() {
      super.setUp()
      // Put setup code here. This method is called before the invocation of each test method in the class.
      
      var layout = SPCollectionViewLayout()
      
   }
   
   override func tearDown() {
      // Put teardown code here. This method is called after the invocation of each test method in the class.
      super.tearDown()
   }
   
   func testLayoutCreation() {
      // This is an example of a functional test case.
      XCTAssert(layout.sectionInset.top == 10 &&
         layout.interItemSpacing == 10 &&
         layout.lineSpacing == 10, "Layout Created")
   }
   
   func testLineSpacing(){
      XCTAssert(layout.lineSpacing(ForSection: 0) == 10, "Linspacing should be valid.")
   }
   
   func testInterItemSpacing(){
      XCTAssert(layout.interItemSpacing(ForSection: 1) == 10, "interItemSpacing should be valid.")
   }

   func testSectionInsetSpacing(){
      XCTAssert(layout.sectionInset(ForSection: 2).top == 10, "sectionInset should be valid.")
   }

   func testLineSpacingFromDelegate(){
      layout.delegate = delegate
      XCTAssert(layout.lineSpacing(ForSection: 0) == 10.5, "Linspacing should be valid.")
   }
   
   func testInterItemSpacingFromDelegate(){
      layout.delegate = delegate
      XCTAssert(layout.interItemSpacing(ForSection: 1) == 21, "interItemSpacing should be valid.")
   }
   
   func testSectionInsetSpacingFromDelegate(){
      layout.delegate = delegate
      XCTAssert(layout.sectionInset(ForSection: 2).top == 30, "sectionInset should be valid.")
   }

   func testUpdateSectionSize(){
      let attr : UICollectionViewLayoutAttributes = UICollectionViewLayoutAttributes()
      attr.frame = CGRect(x: 0, y: 5, width: 50, height: 60)
      
      layout.updateSectionSizeDictionary(OfSection: 0, ByAttributes: attr)
      
      var (width, height) = layout.sectionSizeDictionary[0]!
      XCTAssert(width == 50 &&
         height == 65, "sectionSizeDictionary should be valid.")
      
      attr.frame = CGRect(x: 50, y: 50, width: 50, height: 60)
      layout.updateSectionSizeDictionary(OfSection: 0, ByAttributes: attr)
      (width, height) = layout.sectionSizeDictionary[0]!
      XCTAssert(width == 100 &&
         height == 110, "sectionSizeDictionary should be valid.")

      attr.frame = CGRect(x: 40, y: 40, width: 50, height: 60)
      layout.updateSectionSizeDictionary(OfSection: 0, ByAttributes: attr)
      (width, height) = layout.sectionSizeDictionary[0]!
      XCTAssert(width == 100 &&
         height == 110, "sectionSizeDictionary should be valid.")

      attr.frame = CGRect(x: 40, y: 40, width: 50, height: 60)
      layout.updateSectionSizeDictionary(OfSection: 1, ByAttributes: attr)
      (width, height) = layout.sectionSizeDictionary[1]!
      XCTAssert(width == 90 &&
         height == 100, "sectionSizeDictionary should be valid.")

   }
   
   func testPrepareLayout(){
      let attr : UICollectionViewLayoutAttributes = UICollectionViewLayoutAttributes()
      attr.frame = CGRect(x: 0, y: 5, width: 50, height: 60)
      
      layout.updateSectionSizeDictionary(OfSection: 0, ByAttributes: attr)
      
      layout.prepare()
      XCTAssert(layout.attributesDictionary.count == 0 &&
         layout.sectionSizeDictionary.count == 0, "Prepare Layout should clear all values.")
   }

   func testRoundFloatUptoTwoDecimalPoints(){
      XCTAssert(layout.roundFloatUptoTwoDecimalPoints(18.3333333) == 18.33, "Float Conversion should be valid")
   }
}


class SPTestLayout : NSObject, SPCollectionViewLayoutDelegate{
   ///Gets Line spacing required for that section.
   func lineSpacing(ForSection section : Int) -> CGFloat{
      if section == 0 {
         return 10.5
      }
      return 11.0
   }
   
   ///Gets Inter item spacing required for that section.
   func interItemSpacing(ForSection section : Int) -> CGFloat{
      if section == 0 {
         return 20.5
      }
      return 21.0
   }
   
   ///Gets Section Inset required for that section
   func sectionInset(ForSection section : Int) -> UIEdgeInsets{
      if section == 0 {
         return UIEdgeInsetsMake(20, 20, 20, 20)
      }
      return UIEdgeInsetsMake(30, 30, 30, 30)
      
   }
   
}
