//
//  SPTableViewDatasource.swift
//  SpeedKit
//
//  Created by Pradip Vaghasiya on 13/07/14.
//  Copyright (c) 2014 SpeedUI. All rights reserved.
//

import UIKit
private let kSectionHeaderFooterWithTextHeight : CGFloat  = 20.0

///Generic datasource takes control of Tableview Datasource Management.
///
///Delegate must conform to SPListingViewProtocol
public class SPTableViewDatasource : NSObject, UITableViewDataSource {
   
   /// Weak delegate will be used to fetch all section/cell details for UITableView.
   final unowned var delegate : SPListingViewProtocol
   
   init(_ delegate : SPListingViewProtocol){
      self.delegate = delegate
   }
   
   // MARK: Number Of Sections
   final public func numberOfSectionsInTableView(tableView: UITableView) -> Int
   {
      return self.delegate.spListingData.sectionCount;
   }
   
   // MARK: Number Of Rows in Section
   final public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
   {
      return Int(self.delegate.spListingData.cellCountOfSection(UInt(section)))
   }
   
   // MARK: cellForRowAtIndexPath
   final public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
   {
      if let (cellData, similarCellTypeIndex) = self.delegate.spListingData.getListingCellGroupWithIndexOfCellModelArray(ForIndexPath: indexPath){
         
         let tableViewCell = self.createCellUsing(
            TableView: tableView,
            CellData: cellData,
            IndexPath: indexPath)
         
         self.configureCell(TableViewCell: tableViewCell,
            CellData: cellData, SimilarCellTypeIndex: similarCellTypeIndex)
         
         return tableViewCell
      }
      
      return UITableViewCell()
   }
   
   ///Creates or Dequeues Cell with given Cell Id at given indexPath
   ///
   ///:param: TableView
   ///:param: SPListingCellGroup
   ///:param: IndexPath
   ///
   ///:returns: UITableViewCell If Cell Id is not valid it returns empty default cell.
   private func createCellUsing(TableView tableView: UITableView, CellData cellData: SPListingCellGroup, IndexPath indexPath: NSIndexPath) -> UITableViewCell{
      
      if let cellId = cellData.cellId{
         if (tableView.dequeueReusableCellWithIdentifier(cellId) != nil){
            return tableView.dequeueReusableCellWithIdentifier(cellId, forIndexPath: indexPath)
         }else{
            SPLogger.logError(Message: "Class or Nib named \(cellId) is not registered before dequeing or wrong prototype Cell.")
         }
      }else{
         SPLogger.logWarning(Message: "CellId is nil for IndexPath : \(indexPath.section) - \(indexPath.row)")
      }
      
      return UITableViewCell()   // Returns empty default tabelview cell.
   }
   
   ///Configures Cell if it comforms to SPListingCellProtocol
   ///
   ///:param: TableViewCell
   ///:param: SPListingCellGroup
   ///:param: SimilarCellTypeIndex
   private func configureCell(
      TableViewCell tableViewCell: UITableViewCell,
      CellData cellData: SPListingCellGroup,
      SimilarCellTypeIndex similarCellTypeIndex: Int){
         
         // If Cell conforms to SPListingCellProtocol then configure cell using Cell Common model and model array.
         if let spTableViewCell = tableViewCell as? SPListingCellProtocol{
            
            // Configure cell using cellCommonModel
            if let commonModel:AnyObject = cellData.cellCommonModel {
               spTableViewCell.configureCellUsing(commonModel)
            }
            
            // Configure cell using cellModelArray, This also overrides attributes set by Common model
            if cellData.count > similarCellTypeIndex && similarCellTypeIndex >= 0{
               spTableViewCell.configureCellUsing(cellData[similarCellTypeIndex])
            }
         }
   }
   
   
   // MARK: Section Header & Footer Title
   final public func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
      if let tableViewSection = self.delegate.spListingData[section] as? SPTableViewSection{
         return tableViewSection.sectionHeader
      }
      
      return nil
   }
   
   final public func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
      if let tableViewSection = self.delegate.spListingData[section] as? SPTableViewSection{
         return tableViewSection.sectionFooter
      }
      return nil
      
   }
   
}
