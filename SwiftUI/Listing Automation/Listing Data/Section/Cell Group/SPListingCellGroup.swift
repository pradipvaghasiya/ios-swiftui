//
//  SPListingCellGroup.swift
//  SpeedKit
//
//  Created by Pradip Vaghasiya on 04/08/14.
//  Copyright (c) 2014 Happyfall. All rights reserved.
//

/// SPListingSection contains cell/item details of Tableview/CollectionView section to be used in any listing UI Automation.
///
/// SPListingCellGroup contains list of similar cell type.
/// For Example It can have 20 cell details with 20 data models for given prototype cell. UI Automation creates 20 different cells using these data.

import UIKit


private let kNibFileNameExtension =  "nib"

// MARK: Init
public final class SPListingCellGroup : CollectionType{
   
   /// It can be NibCell,PrototypeCell or SubclassCell based on below fact
   ///
   /// Cell/Item of Collection View or Table View can be created from xib, Storyboard or subclassing UITableViewCell or UICollectionViewCell.
   let cellType: SPCellType
   
   /// This cell id can be
   ///
   /// 1. Reusable Id in Prototype Cell if it is Prototype Cell.
   /// 2. Reusable Id in xib file if it is nib Cell.
   /// 2. SubClass Name if it is Subclass Cell.
   var cellId : String?{
      didSet{
         // If Cell Id is not nil then test wheh
         if self.cellId != nil && self.cellId != oldValue{
            //Assigns Cell id to nil if it is not valid
            self.removeCellIdValueIfInValid()
         }
      }
   }
   
   /// Count of Similar Cells/Items
   var cellCount : UInt{
      didSet{
         if cellModelArray.count > 0 && cellCount != UInt(cellModelArray.count) {
            SPLogger.logWarning(Message: "Cell Model Array contains some values so Cell Count will always be CellModelArray.count. Ignoring your update.")
            self.cellCount = UInt(cellModelArray.count)
         }
      }
   }
   
   /// Common data model for number of Cells (cellCount Above). Automation will create number of cells (cellCount above) using this common model.
   var cellCommonModel: AnyObject?
   
   /// Array of Cells/Items Data Model. cellCount must be same as cellModelArray count if this is set.
   /// Both cellCommonModel and cellModelArray can be set if Cell Supports it. In that case also cellCount must be same as cellModelArray count.
   private var cellModelArray: [AnyObject]{
      didSet{
         self.cellCount = UInt(cellModelArray.count)
      }
   }
   
   public var startIndex = 0
   public var endIndex = 0
   
   init(cellId: String ,
      cellModelArray:[AnyObject],
      cellType: SPCellType = .NibCell){
         
         self.cellId = cellId
         self.cellType = cellType
         self.cellCount = UInt(cellModelArray.count)
         self.cellModelArray = cellModelArray
         endIndex = cellModelArray.count

         self.cellCommonModel = nil
         
         //Assigns Cell id to nil if it is not valid
         self.removeCellIdValueIfInValid()
         
         
   }
      
   init(cellId: String ,
      cellCommonModel : AnyObject,
      cellModelArray:[AnyObject],
      cellType: SPCellType = .NibCell){
         
         self.cellId = cellId
         self.cellType = cellType
         self.cellCount = UInt(cellModelArray.count)
         self.cellModelArray = cellModelArray
         endIndex = cellModelArray.count

         self.cellCommonModel = cellCommonModel
         
         //Assigns Cell id to nil if it is not valid
         self.removeCellIdValueIfInValid()
         
   }
   
   
   init(cellId: String ,
      cellCount: UInt,
      cellCommonModel : AnyObject,
      cellType: SPCellType = .NibCell){
         
         self.cellId = cellId
         self.cellType = cellType
         self.cellCount = cellCount
         self.cellModelArray = []
         endIndex = cellModelArray.count

         self.cellCommonModel = cellCommonModel
         
         //Assigns Cell id to nil if it is not valid
         self.removeCellIdValueIfInValid()
   }
}

extension SPListingCellGroup{
   public subscript (i : Int) -> AnyObject{
      get{
         return cellModelArray[i]
      }
      
      set{
         cellModelArray[i] = newValue
         endIndex = cellModelArray.count
      }
   }
}


// MARK: Cell Id Validation
// Checks whether Nib or Subclass with given cell id exists or not.
extension SPListingCellGroup{
   
   ///Assigns Cell id to nil if it is not valid
   private func removeCellIdValueIfInValid(){
      if self.checkWhetherCellIdIsValid() == false {
         self.cellId = nil
      }
   }
   
   ///Checks whether Cell Id is valid
   ///
   ///:returns: Bool Returns true if valid otherwise false.
   private func checkWhetherCellIdIsValid() -> Bool{
      if let cellId = self.cellId{
         switch self.cellType{
         case .NibCell:
            return self.nibExists(CellId: cellId)
            
         case .SubclassCell:
            return self.viewClassExists(CellId: cellId)
            
         case .PrototypeCell:
            return true
         }
      }
      return false
   }
   
   
   ///Checks whether nib file exists with name equal to cell id.
   ///
   ///:param: CellId which needs to be checked.
   ///
   ///:returns: Bool Returns true if exists otherwise false.
   private func nibExists(CellId cellId: String) -> Bool{
      if NSBundle.mainBundle().pathForResource(cellId, ofType: kNibFileNameExtension) != nil {
         return true
      }
      
      SPLogger.logError(Message: "\(cellId).\(kNibFileNameExtension) does not exist in Application Main Bundle.")
      return false
   }
   
   ///Checks whether class file exists with given name and if subclass of UIView.
   ///
   ///:param: CellId which needs to be checked.
   ///
   ///:returns: Bool Returns true if exists otherwise false.
   private func viewClassExists(CellId cellId: String) -> Bool{
      let givenClass : AnyClass? = NSClassFromString(cellId)
      
      if givenClass == nil {
         SPLogger.logError(Message: "\(cellId) SubClass does not exist in Application.")
         return false
      }
      
      if (givenClass?.isSubclassOfClass(UIView) == nil){
         SPLogger.logError(Message: "\(cellId) Class is not UIView Class.")
         return false
      }
      
      return true
      
   }
}

// MARK: Cell View Type
/// SPCellType defines type based on below fact.
///
/// Cell/Item of Collection View or Table View can be created from xib, Storyboard or subclassing UITableViewCell or UICollectionViewCell.
/// Nib or Subclass Files should be present in main bundle.
enum SPCellType{
   /// If Cell/Item is created from xib.
   case NibCell
   /// If Cell/Item is created from Storyboard Prototype Cell.
   case PrototypeCell
   /// If Cell/Item is created by subclassing UITableViewCell or UICollectionViewCell.
   case SubclassCell
}

