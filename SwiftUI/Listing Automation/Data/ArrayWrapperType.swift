//
//  Sample.swift
//  SpeedKit
//
//  Created by ibm on 26/06/15.
//  Copyright © 2015 speedui. All rights reserved.
//

import Foundation


///TODO: Extending existing Protocols with already defined methods does not work. 
///TODO: items need to be made public though this should hide this

public protocol ArrayWrapperType{
   typealias Element
   var items : [Element] {get set}
}


public extension ArrayWrapperType{
   var startIndex: Int { get {return 0}}
   var endIndex: Int {
      get{
         return items.count
      }
   }
   
   subscript (index: Int) -> Element{
      get{
         return items[index]
      }
      
      set{
         items[index] = newValue
      }
   }
}

public extension ArrayWrapperType{
   public mutating func reserveCapacity(n: Int.Distance){
      items.reserveCapacity(n)
   }
   
    mutating func append(x: Element){
      items.append(x)
   }
   
   mutating func extend<S : SequenceType where S.Generator.Element == Element>(newElements: S){
      items.extend(newElements)
   }
}

public extension ArrayWrapperType{
   mutating func replaceRange<C : CollectionType where C.Generator.Element == Element>(subRange: Range<Int>, with newElements: C){
      items.replaceRange(subRange, with: newElements)
   }
   
   mutating func splice<S : CollectionType where S.Generator.Element == Element>(newElements: S, atIndex i: Int){
      items.splice(newElements, atIndex: i)
   }
   
   
   mutating func removeRange(subRange: Range<Int>){
      items.removeRange(subRange)
   }
   
   mutating func insert(newElement: Element, atIndex i: Int){
      items.insert(newElement, atIndex: i)
   }
   
   mutating func removeAtIndex(index: Int) -> Element{
      return items.removeAtIndex(index)
   }
   
   mutating func removeAll(keepCapacity keepCapacity: Bool){
      items.removeAll(keepCapacity: keepCapacity)
   }
   
}

public extension ArrayWrapperType{
   var count : Int{ get {return items.count}}
}

///TODO: Run time Crash in subscript
public extension ArrayWrapperType where Self.Element : ArrayWrapperType{
//   subscript(indexPath: NSIndexPath) -> Any{
//      get{
//         return self[indexPath.section][indexPath.row]
//      }
//      
//      set{
////         self.items[indexPath.section].items[indexPath.row] = newValue
//      }
//   }
   
   func getItem(indexPath: NSIndexPath) -> Self.Element.Element{
      return self[indexPath.section][indexPath.row]
   }

}

