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
open class SPCollectionViewDataSource : NSObject, UICollectionViewDataSource, SPListingDataSourceType{
    
    unowned public let controller : SPListingControllerType
    
    public init(_ controller : SPListingControllerType){
        self.controller = controller
    }
    
    // MARK: Number Of Sections
    final public func numberOfSections(in collectionView: UICollectionView) -> Int{
        return controller.listingData(collectionView).count
    }
    
    // MARK: Number Of Rows in Section
    final public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return controller.listingData(collectionView)[section].count
    }
    
    // MARK: cellForItemAtIndexPath
    final public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
        let viewModel = controller.listingData(collectionView)[indexPath.section][indexPath.row]
        
        let collectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: viewModel.cellId, for: indexPath)
        
        if let listingCell = collectionViewCell as? SPCollectionCellProtocol{
            listingCell.viewModel = viewModel
            listingCell.collectionView = collectionView
            listingCell.configureCell()
        }
        
        return collectionViewCell
    }
    
}
