//
//  SPListingViewProtocol.swift
//  SpeedKit
//
//  Created by Pradip Vaghasiya on 04/08/14.
//  Copyright (c) 2014 SpeedUI. All rights reserved.
//

/// Any View Controller which wants to use Listing Automation has to conform to this protocol.
public protocol ListingCollectionViewProtocol : class {
   /// It contains content details (Section list) of CollectionView to be used in any listing UI Automation.
   var listingData : ListingData<CollectionViewSection> {get set}

}