//
//  SPListingViewType.swift
//  SwiftUI
//
//  Created by Pradip V on 29/06/15.
//  Copyright © 2015 SpeedUI. All rights reserved.
//

import Foundation

public protocol SPListingViewType : class{
}

public protocol SPListingTableViewType : SPListingViewType{
   weak var controller : SPTableListingControllerType? {get set}
}

public protocol SPListingCollectionViewType : SPListingViewType  {
   weak var controller : SPCollectionListingControllerType? {get set}
}
