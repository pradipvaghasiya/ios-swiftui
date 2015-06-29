//
//  SPCollectionViewDataSource.swift
//  SpeedKit
//
//  Created by Pradip Vaghasiya on 04/08/14.
//  Copyright (c) 2014 SpeedUI. All rights reserved.
//

import UIKit

///Generic datasource takes control of CollectionView Datasource Management.
///
///Delegate must conform to SPListingViewProtocol
public class SPCollectionViewDataSource : NSObject, UICollectionViewDataSource{
   
   unowned var listingCollectionView : SPListingCollectionViewType
   
   public init(_ listingCollectionView : SPListingCollectionViewType){
      self.listingCollectionView = listingCollectionView
   }
   
   // MARK: Number Of Sections
   final public func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int{
      return listingCollectionView.listingData.count
   }
   
   // MARK: Number Of Rows in Section
   final public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
      return listingCollectionView.listingData[section].count
   }
   
   // MARK: cellForItemAtIndexPath
   final public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{
      
      let viewModel = listingCollectionView.listingData[indexPath.section][indexPath.row]
      
      let collectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(viewModel.cellId, forIndexPath: indexPath)
      
      if let listingCell = collectionViewCell as? SPCollectionCellProtocol{
         listingCell.configureCellUsing(viewModel)
         listingCell.parentView = collectionView
      }
      
      return collectionViewCell
   }
   
}
