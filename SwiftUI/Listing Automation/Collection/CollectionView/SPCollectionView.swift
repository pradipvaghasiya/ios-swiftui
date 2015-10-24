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
      super.init(coder: aDecoder)!
   }
}

//MARK: Register Nib Or Subclass
extension SPCollectionView{
   ///Registers all nib file or Subclass which may be in SPListingData for reuse purpose.
   final func registerReusableCellsIfRequired(){
      
      var nibCells : Set<String> = Set()
      var subclassCells : Set<String> = Set()
      
      if let controller = self.controller{
         for section in controller.collectionListingData(self).items{
            for viewModel in section{
               if viewModel.cellType == .Nib{
                  nibCells.insert(viewModel.cellId)
               }else if viewModel.cellType == .SubClass{
                  subclassCells.insert(viewModel.cellId)
               }
            }
         }
      }
      
      for cellId in nibCells{
         self.registerNib(cellId)
      }
      
      for cellId in subclassCells{
         self.registerClass(cellId)
      }

   }
   
   ///Registers given cell using CellData.
   ///
   ///:param: cellData Registers class based on its type and cell Id contained in this param.
   final func registerCellsFor(ViewModel viewModel : ViewModelType){
      switch viewModel.cellType{
      case .SubClass:
         self.registerClass(viewModel.cellId)
      case .Nib:
         self.registerNib(viewModel.cellId)
      case .ProtoType:
         true
      }
   }
   
   
   public final func registerNib(nibId : String){
      self.registerNib(UINib(nibName: nibId, bundle: nil),forCellWithReuseIdentifier: nibId)
   }
   
   public final func registerClass(className : String){
      if let cellClass = NSClassFromString(className){
         if cellClass.isSubclassOfClass(UICollectionViewCell){
            self.registerClass(NSClassFromString(className),forCellWithReuseIdentifier: className)
         }
      }else{
         SPLogger.logError(Message: "\(className) must be subclass of UITableViewCell to use it with SPTableView.")
      }
   }

}


