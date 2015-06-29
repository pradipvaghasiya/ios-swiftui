//
//  SPCellProtocol.swift
//  SpeedKit
//
//  Created by Pradip Vaghasiya on 04/08/14.
//  Copyright (c) 2014 SpeedUI. All rights reserved.
//

/// To Listing Automation to work, Cell or Item must conform to this protocol.
public protocol SPCellProtocol : class{
   
   weak var delegate : UIViewController? {get set}
   
   /// Method to be implemented to configure cell using given data model. Of Course Cell/Item should define this model and view controller will provide the data model to automation.
   ///
   /// :param: model Data model object which is defined by Cell/Item.
   func configureCellUsing(model:ViewModelType);
}
