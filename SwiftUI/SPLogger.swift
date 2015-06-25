//
//  SPLogger.swift
//  SwiftUIDemo
//
//  Created by Pradip Vaghasiya on 29/04/15.
//  Copyright (c) 2015 SpeedUI. All rights reserved.
//

import Foundation

private var kSpeedKitWarningMessagePrefix = "SpeedKit Warning:"
private var kSpeedKitErrorMessagePrefix = "SpeedKit Error:"

final class SPLogger{

   class func logWarning(Message message: String){
      print("\(kSpeedKitWarningMessagePrefix) \(message)")
   }
   
   class func logError(Message message: String){
      print("\(kSpeedKitErrorMessagePrefix) \(message)")
   }
}