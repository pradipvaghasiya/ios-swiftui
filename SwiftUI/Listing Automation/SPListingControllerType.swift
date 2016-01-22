//
//  SPListingController.swift
//  SwiftUI
//
//  Created by ibm on 29/06/15.
//  Copyright © 2015 SpeedUI. All rights reserved.
//

import Foundation
import UIKit

public protocol SPListingControllerType : class{
   
}

//MARK: TableView

public protocol SPTableListingControllerType : SPListingControllerType{
   func tableListingData(tableView : UITableView)->ListingData<TableViewSection>
}

public protocol SPSingleTableListingControllerType : SPTableListingControllerType{
    var tableData : ListingData<TableViewSection> {get set}
}

public extension SPSingleTableListingControllerType{
    public func tableListingData(tableView : UITableView)->ListingData<TableViewSection>{
        return tableData
    }
}

//MARK: CollectionView
public protocol SPCollectionListingControllerType : SPListingControllerType{
    func collectionListingData(collectionView : UICollectionView)->ListingData<CollectionViewSection>
}

public protocol SPSingleCollectionListingControllerType : SPCollectionListingControllerType{
    var collectionData : ListingData<CollectionViewSection> {get set}
}

public extension SPSingleCollectionListingControllerType{
    public func collectionListingData(collectionView: UICollectionView) -> ListingData<CollectionViewSection> {
        return collectionData
    }
}