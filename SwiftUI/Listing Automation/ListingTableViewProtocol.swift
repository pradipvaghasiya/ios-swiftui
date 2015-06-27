//
//  ListingTableViewProtocol.swift
//  SwiftUI
//
//  Created by Pradip Vaghasiya on 26/06/15.
//  Copyright © 2015 SpeedUI. All rights reserved.
//

import Foundation
public protocol ListingTableViewProtocol : class {
   /// It contains content details (Section list) of Tableview to be used in any listing UI Automation.
   var listingData : ListingData<TableViewSection> {get set}
   
}
