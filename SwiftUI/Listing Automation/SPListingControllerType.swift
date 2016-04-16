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
   func listingData(listingView : UIView)->ListingData<ListingSection>
}

public protocol SPSingleSectionListingControllerType : SPListingControllerType{
    var listingData : ListingData<ListingSection> {get set}
}

public extension SPSingleSectionListingControllerType{
    public func listingData(listingView : UIView)->ListingData<ListingSection>{
        return listingData
    }
}

