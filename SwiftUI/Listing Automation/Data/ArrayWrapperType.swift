//
//  Sample.swift
//  SwiftUI
//
//  Created by ibm on 26/06/15.
//  Copyright © 2015 speedui. All rights reserved.
//

import Foundation

public protocol ArrayWrapperType : CollectionType,ExtensibleCollectionType,RangeReplaceableCollectionType,ArrayLiteralConvertible{
   typealias Element
   var items : [Element] {get set}
}

//public extension ArrayWrapperType where Self.Element : SectionType{
//   public subscript (indexPath: NSIndexPath) -> ViewModelType{
//      get{
//         return items[indexPath.section].items[indexPath.row] as! ViewModelType
//      }
//      
//      set{
//         items[indexPath.section].items[indexPath.row]  = newValue
//      }
//   }
//
//}