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
   
   /// Weak delegate will be used to fetch all section/cell details for Collection View.
   final unowned var delegate : SPListingViewProtocol
   
   init(_ delegate : SPListingViewProtocol){
      self.delegate = delegate
   }
   
   // MARK: Number Of Sections
   final public func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int{
      return self.delegate.spListingData.sectionCount
   }
   
   // MARK: Number Of Rows in Section
   final public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
      return  Int(self.delegate.spListingData.cellCountOfSection(UInt(section)))
   }
   
   // MARK: cellForItemAtIndexPath
   final public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{
      var _ : UICollectionViewCell
      
      
      if let (cellData, similarCellTypeIndex) = self.delegate.spListingData.getListingCellGroupWithIndexOfCellModelArray(ForIndexPath: indexPath){
         
         let collectionViewCell = self.createCellUsing(
            CollectionView: collectionView,
            CellData: cellData,
            IndexPath: indexPath)
         
         return collectionViewCell
      }
      
      return UICollectionViewCell()
   }
   
   ///Creates or Dequeues Cell with given Cell Id at given indexPath
   ///
   ///:param: CollectionView
   ///:param: SPListingCellGroup
   ///:param: IndexPath
   ///
   ///:returns: UICollectionViewCell If Cell Id is not valid it returns empty default cell.
   private func createCellUsing(CollectionView collectionView: UICollectionView, CellData cellData: SPListingCellGroup, IndexPath indexPath: NSIndexPath) -> UICollectionViewCell{
      
      if let cellId = cellData.cellId{
         return collectionView.dequeueReusableCellWithReuseIdentifier(cellId, forIndexPath: indexPath)
      }else{
         SPLogger.logWarning(Message: "CellId is nil for IndexPath : \(indexPath.section) - \(indexPath.row)")
      }
      
      return UICollectionViewCell()   // Returns empty default collectionview cell.
   }
   
}
