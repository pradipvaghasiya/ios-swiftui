//
//  SPListingController.swift
//  SwiftUI
//
//  Created by ibm on 29/06/15.
//  Copyright © 2015 SpeedUI. All rights reserved.
//

import Foundation

public protocol SPListingControllerType : class{
   
}

public protocol SPTableListingControllerType : SPListingControllerType{
   var listingData : ListingData<TableViewSection> {get set}
}

public protocol SPCollectionListingControllerType : SPListingControllerType{
   var listingData : ListingData<CollectionViewSection> {get set}
}


