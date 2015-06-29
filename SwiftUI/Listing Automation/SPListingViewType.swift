//
//  SPListingViewType.swift
//  SwiftUI
//
//  Created by ibm on 29/06/15.
//  Copyright © 2015 SpeedUI. All rights reserved.
//

import Foundation

public protocol SPListingViewType : class{
   weak var cellDelegate : UIViewController? {get set}
}

public protocol SPListingTableViewType : SPListingViewType{

   
   /// It contains content details (Section list) of Tableview to be used in any listing UI Automation.
   var listingData : ListingData<TableViewSection> {get set}
   
}


public protocol SPListingCollectionViewType : SPListingViewType  {
   /// It contains content details (Section list) of CollectionView to be used in any listing UI Automation.
   var listingData : ListingData<CollectionViewSection> {get set}
   
}
