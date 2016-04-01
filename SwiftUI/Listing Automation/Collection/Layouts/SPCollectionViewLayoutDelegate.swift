//
//  SPCollectionViewLayoutDelegate.swift
//  SwiftUIDemo
//
//  Created by Pradip Vaghasiya on 02/05/15.
//  Copyright (c) 2015 Happyfall. All rights reserved.
//

import UIKit

///Collection View layout delegate for more control over layout
@objc public protocol SPCollectionViewLayoutDelegate : UICollectionViewDelegate, UIScrollViewDelegate{
   
   ///Gets Line spacing required for that section.
   optional func lineSpacing(ForSection section : Int) -> CGFloat

   ///Gets Inter item spacing required for that section.
   optional func interItemSpacing(ForSection section : Int) -> CGFloat

   ///Gets Section Inset required for that section
   optional func sectionInset(ForSection section : Int) -> UIEdgeInsets
   
}
