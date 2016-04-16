//
//  SPListingViewType.swift
//  SwiftUI
//
//  Created by Pradip V on 29/06/15.
//  Copyright © 2015 Happyfall. All rights reserved.
//

import Foundation

public protocol SPListingViewType : class{
    weak var controller : SPListingControllerType? {get set}
}
