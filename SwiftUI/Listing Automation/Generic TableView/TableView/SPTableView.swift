//
//  SPTableView.swift
//  SpeedKitDemo
//
//  Created by Pradip Vaghasiya on 16/04/15.
//  Copyright (c) 2015 Happyfall. All rights reserved.
//

import UIKit


// MARK: Properties
///TableView instance which can be added via interface builder or code.
///
///Set spListingData - Listing Automation Compatible.
///
///When you add any new Cell from nib or Code in SplistingData you must call registerCellsForCellGroup method.
///
///If you add bulk cell data and not tracking them you can also call registerReusableCellsIfRequired instead of registerCellsForCellGroup. It will register all cells present in listing data. Otherwise it may crash.
public class SPTableView: UITableView,SPListingViewProtocol {
   /// spListingData contains content details (Section list) of Tableview to be used while displaying TableView.
   var spListingData : SPListingData = SPListingData(SectionArray: []){
      didSet{
         // If the spListingData first time gets some values in it.
         if oldValue.spListingSectionArray.count == 0{
            self.registerReusableCellsIfRequired()
         }
      }
   }
   
   ///Generic datasource takes control of Tableview Datasource Management.
   lazy private var spTableDatasource : SPTableViewDatasource = {
      return SPTableViewDatasource(self)
   }()
      
   override public init(frame: CGRect, style: UITableViewStyle = .Plain) {
      super.init(frame: frame, style:style)
      
      //Setup
      self.setupSPTableView()
      
   }
   
   required public init(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
      
      //Setup
      self.setupSPTableView()
   }
   
   ///Sets up Tableview once it is created by Interface Builder or Code
   private func setupSPTableView(){
      
      // Registers Nib before using in Dequeueing
      self.registerReusableCellsIfRequired()
      
      // Table View Datasource setup
      self.dataSource = spTableDatasource
   }
}

