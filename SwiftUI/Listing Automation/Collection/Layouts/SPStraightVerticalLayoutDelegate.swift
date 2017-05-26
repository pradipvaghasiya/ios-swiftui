//
//  SPStraightVerticalLayoutDelegate.swift
//  SwiftUIDemo
//
//  Created by Pradip Vaghasiya on 05/05/15.
//  Copyright (c) 2015 Happyfall. All rights reserved.
//

import UIKit

@objc public protocol SPStraightVerticalLayoutDelegate : SPCollectionViewLayoutDelegate{
   ///Number of Columns for given section
   @objc optional func noOfColumns(ForSection section : Int) -> UInt

   ///Height Of an item
   @objc optional func itemHeightAt(IndexPath indexPath : IndexPath) -> CGFloat
}
