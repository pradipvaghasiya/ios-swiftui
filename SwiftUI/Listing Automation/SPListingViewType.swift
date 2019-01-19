//
//  SPListingViewType.swift
//  SwiftUI
//
//  Created by Pradip V on 29/06/15.
//  Copyright © 2015 Happyfall. All rights reserved.
//

import UIKit

public protocol SPListingViewType : class, UIGestureRecognizerDelegate{
    var controller : SPListingControllerType? {get set} // weak
}
