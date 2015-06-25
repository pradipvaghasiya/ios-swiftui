//
//  SPCollectionViewDataSource.swift
//  SpeedKit
//
//  Created by Pradip Vaghasiya on 04/08/14.
//  Copyright (c) 2014 Happyfall. All rights reserved.
//

import UIKit

///Generic datasource takes control of CollectionView Datasource Management.
///
///Delegate must conform to SPListingViewProtocol
class SPCollectionViewDataSource : NSObject, UICollectionViewDataSource{
   
   /// Weak delegate will be used to fetch all section/cell details for Collection View.
   final unowned var delegate : SPListingViewProtocol
   
   init(_ delegate : SPListingViewProtocol){
      self.delegate = delegate
   }
   
   // MARK: Number Of Sections
   final func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int{
      return self.delegate.spListingData.sectionCount
   }
   
   // MARK: Number Of Rows in Section
   final func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
      return  Int(self.delegate.spListingData.cellCountOfSection(UInt(section)))
   }
   
   // MARK: cellForItemAtIndexPath
   final func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{
      var _ : UICollectionViewCell
      
      
      if let (cellData, similarCellTypeIndex) = self.delegate.spListingData.getListingCellGroupWithIndexOfCellModelArray(ForIndexPath: indexPath){
         
         let collectionViewCell = self.createCellUsing(
            CollectionView: collectionView,
            CellData: cellData,
            IndexPath: indexPath)
         
         self.configureCell(CollectionViewCell: collectionViewCell,
            CellData: cellData, SimilarCellTypeIndex: similarCellTypeIndex)
         
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
   
   ///Configures Cell if it comforms to SPListingCellProtocol
   ///
   ///:param: CollectionViewCell
   ///:param: SPListingCellGroup
   ///:param: SimilarCellTypeIndex
   private func configureCell(
      CollectionViewCell collectionViewCell: UICollectionViewCell,
      CellData cellData: SPListingCellGroup,
      SimilarCellTypeIndex similarCellTypeIndex: Int){
         
         // If Cell conforms to SPListingCellProtocol then configure cell using Cell Common model and model array.
         if let spCollectionViewCell = collectionViewCell as? SPListingCellProtocol{
            
            // Configure cell using cellCommonModel
            if let commonModel:AnyObject = cellData.cellCommonModel {
               spCollectionViewCell.configureCellUsing(commonModel)
            }
            
            // Configure cell using cellModelArray, This also overrides attributes set by Common model
            if cellData.count > similarCellTypeIndex && similarCellTypeIndex >= 0{
               spCollectionViewCell.configureCellUsing(cellData[similarCellTypeIndex])
            }
         }
   }
   
}
