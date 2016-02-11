//
//  SPStraightHorizontalLayoutDelegate.swift
//  FolderDetailUI
//
//  Created by Pradip V on 2/11/16.
//  Copyright © 2016 Speedui. All rights reserved.
//

import UIKit

@objc public protocol SPStraightHorizontalLayoutDelegate : SPCollectionViewLayoutDelegate{
    ///Number of Columns for given section
    optional func noOfRows(ForSection section : Int) -> UInt
    
    ///Height Of an item
    optional func itemWidthAt(IndexPath indexPath : NSIndexPath) -> CGFloat
}
