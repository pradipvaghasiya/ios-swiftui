//
//  SPListingViewType.swift
//  SwiftUI
//
//  Created by Pradip V on 29/06/15.
//  Copyright © 2015 Happyfall. All rights reserved.
//

import Foundation

public protocol SPListingViewType : class{
}

public protocol SPListingTableViewType : SPListingViewType{
   weak var controller : SPListingControllerType? {get set}
}

public protocol SPListingCollectionViewType : SPListingViewType  {
   weak var controller : SPSingleSectionListingControllerType? {get set}
}
