//
//  ViewModelType.swift
//  SwiftUI
//
//  Created by Pradip V on 26/06/15.
//  Copyright © 2015 speedui. All rights reserved.
//

import Foundation

public protocol ViewModelType : class, NSObjectProtocol{
    var cellId : String {get}
    var cellType : CellType {get}
    
    var serverId: Any? {get set}
}

public enum CellType{
   case Nib
   case ProtoType    // Storyboard Cell
   case SubClass
}
