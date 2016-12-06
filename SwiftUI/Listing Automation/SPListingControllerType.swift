//
//  SPListingController.swift
//  SwiftUI
//
//  Created by Pradip V on 29/06/15.
//  Copyright © 2015 Happyfall. All rights reserved.
//

import Foundation
import UIKit

public protocol SPListingControllerType : class{
   func listingData(_ listingView : UIView)->ListingData
}

public protocol SPSingleSectionListingControllerType : SPListingControllerType{
    var listingData : ListingData {get set}
}

public extension SPSingleSectionListingControllerType{
    public func listingData(_ listingView : UIView)->ListingData{
        return listingData
    }
}

