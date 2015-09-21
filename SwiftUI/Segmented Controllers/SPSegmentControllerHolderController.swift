//
//  SPSegmentControllerHolderController.swift
//  SwiftUIDemo
//
//  Created by Pradip Vaghasiya on 30/11/14.
//  Copyright (c) 2014 SpeedUI. All rights reserved.
//

import UIKit

class SPSegmentControllerHolderController : UIViewController{
    private let viewControllers : [UIViewController]
    
    init(viewControllers : [UIViewController]) {
        self.viewControllers = viewControllers
        super.init(nibName: nil,bundle: nil)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        self.viewControllers = []
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init(coder aDecoder: NSCoder) {
        self.viewControllers = []
        super.init(coder: aDecoder)!
    }

}