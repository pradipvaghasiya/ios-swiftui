//
//  SPFixedColumnRowVerticalLayoutDelegate.swift
//  SwiftUIDemo
//
//  Created by Pradip Vaghasiya on 02/05/15.
//  Copyright (c) 2015 Happyfall. All rights reserved.
//

import UIKit

@objc public protocol SPFixedColumnRowLayoutDelegate : SPCollectionViewLayoutDelegate{
   ///Number of Rows for given section
   optional func noOfRows(ForSection section : Int) -> UInt
   
   ///Number of Columns for given section
   optional func noOfColumns(ForSection section : Int) -> UInt
}


