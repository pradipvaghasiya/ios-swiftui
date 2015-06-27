//
//  SPCollectionView.swift
//  SwiftUIDemo
//
//  Created by Pradip Vaghasiya on 30/04/15.
//  Copyright (c) 2015 SpeedUI. All rights reserved.
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
public class SPCollectionView: UICollectionView,ListingCollectionViewProtocol {

   /// spListingData contains content details (Section list) of CollectionView to be used while displaying CollectionView.
   public var listingData : ListingData<CollectionViewSection> {
      didSet{
         spCollectionDatasource.listingData = listingData
         
         // If the spListingData first time gets some values in it.
         if oldValue.count == 0{
            self.registerReusableCellsIfRequired()
         }
      }
   }

   ///Generic datasource takes control of Collectionview Datasource Management.
   private var spCollectionDatasource : SPCollectionViewDataSource
   
   public override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout){
      listingData = ListingData(sections: [])
      spCollectionDatasource = SPCollectionViewDataSource(listingData)

      super.init(frame: frame, collectionViewLayout : layout)
      
      //Setup
      self.setupSPCollectionView()
      
   }
   
   public required init(coder aDecoder: NSCoder) {
      listingData = ListingData(sections: [])
      spCollectionDatasource = SPCollectionViewDataSource(listingData)

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

      self.dataSource = spCollectionDatasource
   }
}

//MARK: Register Nib Or Subclass
extension SPCollectionView{
   ///Registers all nib file or Subclass which may be in SPListingData for reuse purpose.
   final func registerReusableCellsIfRequired(){
      for section in listingData.items{
         for viewModel in section.items{
            self.registerCellsFor(ViewModel: viewModel)
         }
      }
   }
   
   ///Registers given cell using CellData.
   ///
   ///:param: cellData Registers class based on its type and cell Id contained in this param.
   final func registerCellsFor(ViewModel viewModel : ViewModelType){
      switch viewModel.cellType{
      case .SubClass:
         if let cellClass = NSClassFromString(viewModel.cellId){
            if cellClass.isSubclassOfClass(UICollectionViewCell) {
               self.registerClass(NSClassFromString(viewModel.cellId), forCellWithReuseIdentifier: viewModel.cellId)
            }
         }else{
            SPLogger.logError(Message: "\(viewModel.cellId) must be subclass of UICollectionViewCell to use it with SPCollectionView.")
         }
      case .Nib:
         self.registerNib(UINib(nibName: viewModel.cellId, bundle: nil),
            forCellWithReuseIdentifier: viewModel.cellId)
         
      case .ProtoType:
         true
      }
      
   }
}

