//
//  SPListingColumnBasedLayoutInvalidationContext.swift
//  SwiftUIDemo
//
//  Created by Pradip Vaghasiya on 26/11/14.
//  Copyright (c) 2014 SpeedUI. All rights reserved.
//

import UIKit

class SPListingColumnBasedLayoutInvalidationContext : UICollectionViewLayoutInvalidationContext{
    // Store new lengths of items
    var preferredSizeOfItems : [NSIndexPath : CGSize] = [:]
}
