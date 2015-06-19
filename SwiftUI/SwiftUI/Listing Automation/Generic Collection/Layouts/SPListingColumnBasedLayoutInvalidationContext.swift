//
//  SPListingColumnBasedLayoutInvalidationContext.swift
//  SpeedKitDemo
//
//  Created by Pradip Vaghasiya on 26/11/14.
//  Copyright (c) 2014 Happyfall. All rights reserved.
//

import UIKit

class SPListingColumnBasedLayoutInvalidationContext : UICollectionViewLayoutInvalidationContext{
    // Store new lengths of items
    var preferredSizeOfItems : [NSIndexPath : CGSize] = [:]
}
