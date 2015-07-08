//
//  SPLogger.swift
//  SwiftUIDemo
//
//  Created by Pradip Vaghasiya on 29/04/15.
//  Copyright (c) 2015 SpeedUI. All rights reserved.
//

import Foundation

private var kSwiftUIWarningMessagePrefix = "SwiftUI Warning:"
private var kSwiftUIErrorMessagePrefix = "SwiftUI Error:"

final class SPLogger{

   class func logWarning(Message message: String){
      print("\(kSwiftUIWarningMessagePrefix) \(message)")
   }
   
   class func logError(Message message: String){
      print("\(kSwiftUIErrorMessagePrefix) \(message)")
   }
}