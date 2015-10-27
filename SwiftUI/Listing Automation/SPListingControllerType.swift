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
   func tableListingData(tableView : UITableView)->ListingData<TableViewSection>
}

public protocol SPCollectionListingControllerType : SPListingControllerType{
   func collectionListingData(collectionView : UICollectionView)->ListingData<CollectionViewSection>
}

public protocol SPSingleCollectionListingControllerType : SPCollectionListingControllerType{
    weak var collectionView: SPCollectionView! {get set}
    var collectionData : ListingData<CollectionViewSection> {get set}
}

public extension SPSingleCollectionListingControllerType{
    public func collectionListingData(collectionView: UICollectionView) -> ListingData<CollectionViewSection> {
        return collectionData
    }
}