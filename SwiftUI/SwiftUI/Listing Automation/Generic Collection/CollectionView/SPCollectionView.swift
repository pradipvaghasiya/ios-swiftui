//
//  SPCollectionView.swift
//  SpeedKitDemo
//
//  Created by Pradip Vaghasiya on 30/04/15.
//  Copyright (c) 2015 Happyfall. All rights reserved.
//

import UIKit

// MARK: Properties
///CollectionView instance which can be added via interface builder or code.
///
///Set spListingData - Listing Automation Compatible.
///
///When you add any new Cell from nib or Code in SplistingData you must call registerCellsForCellGroup method.
///
///If you add bulk cell data and not tracking them you can also call registerReusableCellsIfRequired instead of registerCellsForCellGroup. It will register all cells present in listing data. Otherwise it may crash.
class SPCollectionView: UICollectionView,SPListingViewProtocol {

   /// spListingData contains content details (Section list) of CollectionView to be used while displaying CollectionView.
   var spListingData : SPListingData = SPListingData(SectionArray: []){
      didSet{
         // If the spListingData first time gets some values in it.
         if oldValue.spListingSectionArray.count == 0{
            self.registerReusableCellsIfRequired()
         }
      }
   }

   ///Generic datasource takes control of Collectionview Datasource Management.
   private var spCollectionDatasource : SPCollectionViewDataSource?
   
   override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout){
      super.init(frame: frame, collectionViewLayout : layout)
      
      //Setup
      self.setupSPCollectionView()
      
   }
   
   required init(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
      
      //Setup
      self.setupSPCollectionView()
   }
}

// MARK: Setup SPCollectionView
extension SPCollectionView{
   ///Sets up CollectionView once it is created by Interface Builder or Code
   private func setupSPCollectionView(){
      
      // Registers Nib before using in Dequeueing
      self.registerReusableCellsIfRequired()
      
      // Collection View Datasource setup
      spCollectionDatasource = SPCollectionViewDataSource(self)
      
      if spCollectionDatasource != nil{
         self.dataSource = spCollectionDatasource!
      }
   }
}

//MARK: Register Nib Or Subclass
extension SPCollectionView{
   ///Registers all nib file or Subclass which may be in SPListingData for reuse purpose.
   final func registerReusableCellsIfRequired(){
      for sectionDetail in spListingData.spListingSectionArray{
         for cellData in sectionDetail.spCellGroupArray{
            self.registerCellsFor(CellGroup: cellData)
         }
      }
   }
   
   ///Registers given cell using CellData.
   ///
   ///:param: cellData Registers class based on its type and cell Id contained in this param.
   final func registerCellsFor(CellGroup cellGroup : SPListingCellGroup){
      if let cellId = cellGroup.cellId{
         switch cellGroup.cellType{
         case .SubclassCell:
            if let cellClass = NSClassFromString(cellId){
               if cellClass.isSubclassOfClass(UICollectionViewCell) {
                  self.registerClass(NSClassFromString(cellId), forCellWithReuseIdentifier: cellId)
               }
            }else{
               SPLogger.logError(Message: "\(cellId) must be subclass of UICollectionViewCell to use it with SPCollectionView.")
            }
         case .NibCell:
            self.registerNib(UINib(nibName: cellId, bundle: nil),
               forCellWithReuseIdentifier: cellId)
            
         case .PrototypeCell:
            true
         }
         
      }
   }
}

