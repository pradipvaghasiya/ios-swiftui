//
//  SPStraightVerticalLayoutDelegate.swift
//  SpeedKitDemo
//
//  Created by Pradip Vaghasiya on 05/05/15.
//  Copyright (c) 2015 Happyfall. All rights reserved.
//

import UIKit

@objc protocol SPStraightVerticalLayoutDelegate : SPCollectionViewLayoutDelegate{
   ///Number of Columns for given section
   optional func noOfColumns(ForSection section : Int) -> UInt

   ///Height Of an item
   optional func itemHeightAt(IndexPath indexPath : NSIndexPath) -> CGFloat
}