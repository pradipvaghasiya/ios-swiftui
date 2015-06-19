//
//  SPUIHelper.swift
//  SpeedKitDemo
//
//  Created by Pradip Vaghasiya on 14/04/15.
//  Copyright (c) 2015 Happyfall. All rights reserved.
//

import UIKit

/// UI Helper class which contains reusable code to display UI elements.
///
/// 1. Show Alert.
/// 2. Add View controller to container controller
final class SPUIHelper{
    
    // MARK: 1. Show Alert
    /// It displays alert with given warning message with Title "Warning".
    ///
    /// :param: message Message to be displayed
    /// :param: viewcontroller on which alert controller needs to be displayed. Required for iOS 8 and above.
    @available(iOS, introduced=7.0)
    class func showWarningAlert(WithMessage message:String, OnViewController viewController:UIViewController) {
        if #available(iOS 8.0, *) {
            // Create Alert Controller with given message.
            let alertController = UIAlertController(title: "Warning", message: message, preferredStyle: .Alert)
            // Add Action
            let cancelAction = UIAlertAction(title:"Ok", style: .Cancel, handler: nil)
            alertController.addAction(cancelAction)
            
            // Present alert controller.
            viewController.presentViewController(alertController, animated: true, completion: nil)
        } else {
            // Fallback on earlier versions
///TODO: Add UIALert for iOS 7
        }
    }
    
    /// It displays alert with given title and message.
    ///
    /// :param: title Title to be displayed
    /// :param: message Message to be displayed
    /// :param: viewcontroller on which alert controller needs to be displayed. Required for iOS 8 and above.
    @available(iOS, introduced=7.0)
    class func showSimpleAlert(WithTitle title:String, WithMessage message:String, OnViewController viewController:UIViewController) {
        if #available(iOS 8.0, *) {
            // Create Alert Controller with given message.
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
            
            // Add Action
            let cancelAction = UIAlertAction(title:"Ok", style: .Cancel, handler: nil)
            alertController.addAction(cancelAction)
            
            // Present alert controller.
            viewController.presentViewController(alertController, animated: true, completion: nil)

        } else {
            // Fallback on earlier versions
///TODO: Add UIALert for iOS 7

        }
    }
    
    // MARK: 2. Add View controller to container controller
    /// Class method to add given child view controller into given parent view controller at given frame.
    ///
    /// :param: childViewController View controller you want to add.
    /// :param: parentViewController View controller you want to add into.
    /// :param: insideView View inside which view of child controller should go
    /// :param: frame Required frame of child view controller
    class func add(child childViewController: UIViewController,
        into parentViewController: UIViewController,
        insideView view:UIView,
        atPosition frame: CGRect)
    {
        parentViewController.addChildViewController(childViewController) // This will call willMoveToParentViewController automatically
        childViewController.view.frame = frame
        view.addSubview(childViewController.view)
        childViewController.didMoveToParentViewController(parentViewController)
    }

}