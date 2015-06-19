//
//  SPListingColumnBasedLayoutDatasource.swift
//  SpeedKitDemo
//
//  Created by Pradip Vaghasiya on 17/11/14.
//  Copyright (c) 2014 Happyfall. All rights reserved.
//

import UIKit

// Remove Objc in newer version if not required.
@objc protocol SPListingColumnBasedLayoutDelegate : UICollectionViewDelegate{
    // Scrolling Lines
    optional func collectionView(collectionView: UICollectionView?, layout collectionViewLayout: UICollectionViewLayout, numberOfScrollingLinesAtSection section: Int) -> Int
    
    // Length
    optional func collectionView(collectionView: UICollectionView?, layout collectionViewLayout: UICollectionViewLayout, numberOfLinesShouldFitInPage section: Int) -> Int   // This method will be ignored if lengthOfItemAtIndexPath is implemented.
    
    // itemWidthOrHeight indicates width if it is vertical layout and height if it is horizontal layout
    optional func collectionView(collectionView: UICollectionView?, layout collectionViewLayout: UICollectionViewLayout, lengthOfItemAtIndexPath indexPath: NSIndexPath, forGivenWidthOrHeight itemWidthOrHeight:CGFloat) -> CGFloat
    
    // Spacing
    optional func collectionView(collectionView: UICollectionView?, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets
    optional func collectionView(collectionView: UICollectionView?, layout collectionViewLayout: UICollectionViewLayout, lineSpacingForSectionAtIndex section: Int) -> CGFloat
    optional func collectionView(collectionView: UICollectionView?, layout collectionViewLayout: UICollectionViewLayout, interitemSpacingForSectionAtIndex section: Int) -> CGFloat

    // Header & Footer
    optional func collectionView(collectionView: UICollectionView?, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize
    optional func collectionView(collectionView: UICollectionView?, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize
}
