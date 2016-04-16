//
//  SPTableView.swift
//  SwiftUIDemo
//
//  Created by Pradip Vaghasiya on 16/04/15.
//  Copyright (c) 2015 Happyfall. All rights reserved.
//

import UIKit

public class SPTableView: UITableView, SPListingViewType {
   
   public weak var controller : SPListingControllerType? {
      didSet{
         if oldValue == nil && controller != nil{
            self.registerReusableCellsIfRequired()
            self.listingDataSource = SPTableViewDataSource(controller!)
            self.dataSource = self.listingDataSource
         }
      }
   }
   
   private var listingDataSource : SPTableViewDataSource?
   
   override public init(frame: CGRect, style: UITableViewStyle = .Plain) {
      super.init(frame: frame, style: style)
   }
   
   required public init(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)!      
   }
   
}

//MARK: Register Nib Or Subclass
extension SPTableView{
   ///Registers all nib file or Subclass which may be in SPListingData for reuse purpose.
   public final func registerReusableCellsIfRequired(){
      var nibCells : Set<String> = Set()
      var subclassCells : Set<String> = Set()
      
      if let controller = self.controller{
         for section in controller.listingData(self).items{
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
   public final func registerCellsFor(ViewModel viewModel : ViewModelType){
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
      self.registerNib(UINib(nibName: nibId, bundle: nil),forCellReuseIdentifier: nibId)
   }

   public final func registerClass(className : String){
      if let cellClass = NSClassFromString(className){
         if cellClass.isSubclassOfClass(UITableViewCell){
            self.registerClass(NSClassFromString(className),forCellReuseIdentifier: className)
         }
      }else{
         SPLogger.logError(Message: "\(className) must be subclass of UITableViewCell to use it with SPTableView.")
      }
   }

}


