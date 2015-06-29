//
//  SPTableView.swift
//  SwiftUIDemo
//
//  Created by Pradip Vaghasiya on 16/04/15.
//  Copyright (c) 2015 SpeedUI. All rights reserved.
//

import UIKit

public class SPTableView: UITableView,SPListingTableViewType {
   
   public weak var controller : SPTableListingControllerType? {
      didSet{
         if oldValue == nil && controller != nil{
            self.registerReusableCellsIfRequired()
            self.tableDataSource = SPTableViewDataSource(controller!)
            self.dataSource = self.tableDataSource
         }
      }
   }
   
   private var tableDataSource : SPTableViewDataSource?
   
   override public init(frame: CGRect, style: UITableViewStyle = .Plain) {
      super.init(frame: frame, style: style)
   }
   
   required public init(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)      
   }
   
}

//MARK: Register Nib Or Subclass
extension SPTableView{
   ///Registers all nib file or Subclass which may be in SPListingData for reuse purpose.
   public final func registerReusableCellsIfRequired(){
      if let controller = self.controller{
         for section in controller.tableListingData(self).items{
            for viewModel in section.items{
               self.registerCellsFor(ViewModel: viewModel)
            }
         }         
      }
   }
   
   ///Registers given cell using CellData.
   ///
   ///:param: cellData Registers class based on its type and cell Id contained in this param.
   public final func registerCellsFor(ViewModel viewModel : ViewModelType){
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


