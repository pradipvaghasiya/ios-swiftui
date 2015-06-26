//
//  SPTable+RegisterCells.swift
//  SwiftUIDemo
//
//  Created by ibm on 19/06/15.
//  Copyright © 2015 SpeedUI. All rights reserved.
//

import UIKit

//MARK: Register Nib Or Subclass
extension SPTableView{
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
            if cellClass.isSubclassOfClass(UITableViewCell){
               self.registerClass(NSClassFromString(viewModel.cellId),forCellReuseIdentifier: viewModel.cellId)
            }
         }else{
            SPLogger.logError(Message: "\(viewModel.cellId) must be subclass of UITableViewCell to use it with SPTableView.")
         }
      case .Nib:
         self.registerNib(UINib(nibName: viewModel.cellId, bundle: nil),
            forCellReuseIdentifier: viewModel.cellId)
         
      case .ProtoType:
         true
      }
      
   }
}
