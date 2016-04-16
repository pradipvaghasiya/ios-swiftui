//
//  SPTableViewDatasource.swift
//  SwiftUI
//
//  Created by Pradip Vaghasiya on 13/07/14.
//  Copyright (c) 2014 Happyfall. All rights reserved.
//

import UIKit

///Generic datasource takes control of Tableview Datasource Management.
///
///Delegate must conform to SPListingViewProtocol
public class SPTableViewDataSource : NSObject, UITableViewDataSource, SPListingDataSourceType {
    unowned public let controller : SPListingControllerType
    
    public init(_ controller : SPListingControllerType){
        self.controller = controller
    }
    
    // MARK: Number Of Sections
    final public func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return controller.listingData(tableView).count
    }
    
    // MARK: Number Of Rows in Section
    final public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return controller.listingData(tableView)[section].count
    }
    
    // MARK: cellForRowAtIndexPath
    final public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let viewModel = controller.listingData(tableView)[indexPath.section][indexPath.row]
        
        let tableViewCell = self.createCellUsing(
            TableView: tableView,
            ViewModelType: viewModel,
            IndexPath: indexPath)
        
        if let listingCell = tableViewCell as? SPTableCellProtocol{
            listingCell.viewModel = viewModel
            listingCell.tableView = tableView
            listingCell.configureCell()
        }
        
        return tableViewCell
    }
    
    ///Creates or Dequeues Cell with given Cell Id at given indexPath
    ///
    ///:param: TableView
    ///:param: SPListingCellGroup
    ///:param: IndexPath
    ///
    ///:returns: UITableViewCell If Cell Id is not valid it returns empty default cell.
    private func createCellUsing(TableView tableView: UITableView,
        ViewModelType viewModel: ViewModelType,
        IndexPath indexPath: NSIndexPath) -> UITableViewCell{
            
            if (tableView.dequeueReusableCellWithIdentifier(viewModel.cellId) != nil){
                return tableView.dequeueReusableCellWithIdentifier(viewModel.cellId, forIndexPath: indexPath)
            }else{
                SPLogger.logError(Message: "Class or Nib named \(viewModel.cellId) is not registered before dequeing or wrong prototype Cell.")
            }
            
            return UITableViewCell()   // Returns empty default tabelview cell.
    }
    
    
    // MARK: Section Header & Footer Title
    final public func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return controller.listingData(tableView)[section].sectionHeader
    }
    
    final public func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return controller.listingData(tableView)[section].sectionFooter
    }
}
