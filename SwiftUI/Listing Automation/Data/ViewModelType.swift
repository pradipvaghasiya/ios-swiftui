//
//  ViewModelType.swift
//  SpeedKit
//
//  Created by ibm on 26/06/15.
//  Copyright © 2015 speedui. All rights reserved.
//

import Foundation

public protocol ViewModelType {
   var cellId : String {get}
   var cellType : CellType {get}
}

public enum CellType{
   case Nib
   case ProtoType    // Storyboard Cell
   case SubClass
}
