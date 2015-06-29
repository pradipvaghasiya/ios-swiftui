//
//  SPCollectionView.swift
//  SwiftUIDemo
//
//  Created by Pradip Vaghasiya on 30/04/15.
//  Copyright (c) 2015 SpeedUI. All rights reserved.
//

import UIKit

public class SPCollectionView: UICollectionView,SPListingCollectionViewType {

   public weak var controller : SPCollectionListingControllerType?
      {
      didSet{
         if oldValue == nil && controller != nil{
            self.registerReusableCellsIfRequired()
            self.collectionDataSource = SPCollectionViewDataSource(controller!)
            self.dataSource = self.collectionDataSource
         }
      }
   }
   
   private var collectionDataSource : SPCollectionViewDataSource?

   public required init(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
   }
}

//MARK: Register Nib Or Subclass
extension SPCollectionView{
   ///Registers all nib file or Subclass which may be in SPListingData for reuse purpose.
   final func registerReusableCellsIfRequired(){
      if let controller = self.controller{
         for section in controller.listingData.items{
            for viewModel in section.items{
               self.registerCellsFor(ViewModel: viewModel)
            }
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

