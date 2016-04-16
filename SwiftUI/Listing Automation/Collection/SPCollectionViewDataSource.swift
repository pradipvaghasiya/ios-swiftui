//
//  SPCollectionViewDataSource.swift
//  SwiftUI
//
//  Created by Pradip Vaghasiya on 04/08/14.
//  Copyright (c) 2014 Happyfall. All rights reserved.
//

import UIKit

///Generic datasource takes control of CollectionView Datasource Management.
///
///Delegate must conform to SPListingViewProtocol
public class SPCollectionViewDataSource : NSObject, UICollectionViewDataSource, SPCollectionListingDataSourceType{
    
    unowned public let controller : SPSingleSectionListingControllerType
    
    public init(_ controller : SPSingleSectionListingControllerType){
        self.controller = controller
    }
    
    // MARK: Number Of Sections
    final public func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int{
        return controller.listingData(collectionView).count
    }
    
    // MARK: Number Of Rows in Section
    final public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return controller.listingData(collectionView)[section].count
    }
    
    // MARK: cellForItemAtIndexPath
    final public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{
        
        let viewModel = controller.listingData(collectionView)[indexPath.section][indexPath.row]
        
        let collectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(viewModel.cellId, forIndexPath: indexPath)
        
        if let listingCell = collectionViewCell as? SPCollectionCellProtocol{
            listingCell.viewModel = viewModel
            listingCell.collectionView = collectionView
            listingCell.configureCell()
        }
        
        return collectionViewCell
    }
    
}
